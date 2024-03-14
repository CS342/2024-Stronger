These MATLAB files contain the information about the composition of the Food-475 Dataset and the split used in training the classifier as found in the paper:

The Food-475 Dataset is a refinement of the Food524DB composite dataset [1] (http://www.ivl.disco.unimib.it/activities/food524db/
) that contains images taken from the four food datasets: UECFOOD256 [2], VIREO [3], Food-101 [4], and Food-50 [5].

Each Matlab file contains three variables structured as follows:

name : cell array of strings containing the unique name of the foods (e.g. "Almond jelly")

id : cell array of strings containing the unique id of the foods (e.g. "almondjelly")

images: container Map  where each entry, indexed by id, is a cell array of strings with the file names of the food images belonging to the id class

The filenames of the food images, with the exception of UECFOOD256, follow the structure of the original datasets (e.g. VIREO/2/1_0.jpg, Food-101/images/apple_pie/134.jpg, food50/Arepas/20_arepas_001.jpg). For the dataset UECFOOD256, crops of the single food instances are used instead. These are extracted from the given bounding boxes (see the paper for more details). For convenience, this modified dataset is also provided in the UECFOOD256crop.zip archive. The filename structure is as UECFOOD256/1/1.jpg. 

[1] Gianluigi Ciocca, Paolo Napoletano, Raimondo Schettini: Learning CNN-based Features for Retrieval of Food Images
In New Trends in Image Analysis and Processing -- ICIAP 2017: ICIAP International Workshops, WBICV, SSPandBE, 3AS, RGBD, NIVAR, IWBAAS, and MADiMa 2017, Catania, Italy, September 11-15, 2017, Revised Selected Papers, Cham, pp. 426-434, Springer International Publishing, 2017. 

[2] Kawano, Y., Yanai, K.: Automatic expansion of a food image dataset leverag-ing existing categories with domain adaptation. 
In: Proc. of ECCV Workshop on Transferring and Adapting Source Knowledge in Computer Vision (2014)

[3] Chen, J., Ngo, C.W.: Deep-based ingredient recognition for cooking recipe retrieval.
In: Proc. of the 2016 ACM on Multimedia Conference. pp. 32{41. ACM (2016)

[4] Bossard, L., Guillaumin, M., Van Gool, L.: Food-101{mining discriminative compo-nents with random forests. In: Computer Vision{ECCV 2014, pp. 446{461 (2014)

[5] Chen, M. Y., Yang, Y. H., Ho, C. J., Wang, S. H., Liu, S. M., Chang, E., Ouhyoung, M. (2012, November). Automatic chinese food identification and quantity estimation. In SIGGRAPH Asia 2012 Technical Briefs (p. 29). ACM.
