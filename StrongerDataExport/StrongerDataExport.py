#
# This source file is part of the Stanford Spezi open-source project
#
# SPDX-FileCopyrightText: 2024 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

# Standard Library Imports
import os
from datetime import datetime
from typing import List, Dict

# Firebase and Google Cloud Firestore Imports
import firebase_admin
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1.client import Client

# Data Handling and Scientific Computing Libraries
import pandas as pd
import numpy as np


def connect_to_firebase(project_id: str, serviceAccountKey_file: str = None) -> Client:
    
    if not serviceAccountKey_file and not project_id:
        project_id = "strongerdatapipeline"
        os.environ["FIRESTORE_EMULATOR_HOST"] = "localhost:8080"
        os.environ["GCLOUD_PROJECT"] = project_id
        firebase_admin.initialize_app(options={'projectId': project_id})
        db = firestore.Client(project=project_id)    

    elif serviceAccountKey_file and project_id:
        if not firebase_admin._apps:
            cred = credentials.Certificate(serviceAccountKey_file)
            firebase_admin.initialize_app(cred)
            db = firestore.client()

    return db


def fetch_data(db: Client, collection_name: str = 'users') -> Dict[str, List[Dict]]:
    users_ref = db.collection(collection_name)
    users_docs = users_ref.stream()

    data = {
        "ProteinIntake": [],
        "exerciseLog": []
    }

    for doc in users_docs:
        user_data = doc.to_dict()
        user_id = doc.id
        user_data_prefixed = {'user_id': user_id}
        user_data_prefixed.update(user_data)

        protein_ref = users_ref.document(user_id).collection('ProteinIntake')
        protein_docs = protein_ref.stream()
        for protein_doc in protein_docs:
            protein_data = protein_doc.to_dict()
            protein_data_final = user_data_prefixed.copy()
            protein_data_final.update(protein_data)
            data["ProteinIntake"].append(protein_data_final)

        exercise_ref = users_ref.document(user_id).collection('exerciseLog')
        exercise_docs = exercise_ref.stream()
        for exercise_doc in exercise_docs:
            exercise_data = exercise_doc.to_dict()
            exercise_data_final = user_data_prefixed.copy()
            exercise_data_final.update(exercise_data)
            data["exerciseLog"].append(exercise_data_final)

    return data


def flatten_data(data: Dict[str, List[Dict]], save_as_csv: bool = True) -> tuple[pd.DataFrame, pd.DataFrame]:
    protein_df = pd.DataFrame(data["ProteinIntake"])
    exercise_df = pd.DataFrame(data["exerciseLog"])

    if save_as_csv:
        save_dataframe_to_csv(protein_df, f'protein_intake_{datetime.now().strftime("%Y-%m-%d")}.csv')
        save_dataframe_to_csv(exercise_df, f'exercise_log_{datetime.now().strftime("%Y-%m-%d")}.csv')

    return protein_df, exercise_df


def process_data(db: Client, collection_name: str = 'users', save_as_csv: bool = True) -> tuple[pd.DataFrame, pd.DataFrame]:
    users_df = fetch_users_list(db, collection_name)
    data = fetch_data(db, collection_name)
    protein_df, exercise_df = flatten_data(data) 

    return users_df, protein_df, exercise_df


def save_dataframe_to_csv(df: pd.DataFrame, filename: str) -> None:
    df.to_csv(filename, index=False)

          
def fetch_users_list(db: Client, collection_name: str = 'users', save_as_csv: bool = False) -> pd.DataFrame:
    users = db.collection(collection_name).stream()
    users_data = []
    all_identifiers = set()

    for user in users:
        user_data = user.to_dict()
        if user_data:
            user_data['User Document ID'] = user.id
            users_data.append(user_data)
            all_identifiers.update(user_data.keys())

    df = pd.DataFrame(users_data)

    # This step is optional and depends on the need for consistency in the DataFrame's structure
    for identifier in all_identifiers:
        if identifier not in df.columns:
            df[identifier] = None

    column_order = ['User Document ID'] + [col for col in df.columns if col != 'User Document ID']
    df = df[column_order]

    if save_as_csv:
        filename = f'users_list_{datetime.now().strftime("%Y-%m-%d")}.csv'
        save_dataframe_to_csv(df, filename)

    return df


def convert_to_snake_case(s: str) -> str:
    return s.lower().replace(" ", "_")
