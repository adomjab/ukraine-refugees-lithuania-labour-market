|                       |model 1           |model 2          |model 3         |model 4           |
|:----------------------|:-----------------|:----------------|:---------------|:-----------------|
|Dependent Var.:        |low_skill         |low_skill        |low_skill       |low_skill         |
|                       |                  |                 |                |                  |
|treat x post           |-0.0095* (0.0038) |-0.0040 (0.0035) |                |-0.0065* (0.0030) |
|treated_unit x post    |                  |                 |0.0231 (0.0240) |                  |
|Population weights     |                  |                 |                |Yes               |
|Heterogeneous trends   |                  |Yes              |Yes             |Yes               |
|Treated municipalities |10                |10               |10              |10                |
|Control municipalities |50                |50               |26              |50                |
|Fixed-Effects:         |----------------- |---------------- |--------------- |----------------- |
|municipality           |Yes               |Yes              |No              |Yes               |
|date                   |Yes               |Yes              |Yes             |Yes               |
|match_id               |No                |No               |Yes             |No                |
|______________________ |_________________ |________________ |_______________ |_________________ |
|S.E.: Clustered        |by: municipality  |by: municipality |by: match_id    |by: municipality  |
|Observations           |4,320             |4,320            |4,248           |4,320             |
|R2                     |0.96897           |0.97548          |0.75603         |0.99573           |
|Dep. Var. mean         |0.47489           |0.47489          |0.48266         |0.47489           |
|RMSE                   |0.01063           |0.00945          |0.03289         |0.00089           |
