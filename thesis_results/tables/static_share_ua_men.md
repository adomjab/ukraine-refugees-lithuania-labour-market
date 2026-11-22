|                       |model 1          |model 2            |model 3          |model 4            |
|:----------------------|:----------------|:------------------|:----------------|:------------------|
|Dependent Var.:        |share_ua         |share_ua           |share_ua         |share_ua           |
|                       |                 |                   |                 |                   |
|treat x post           |-1.192* (0.5195) |-1.482*** (0.4235) |                 |-1.140*** (0.3273) |
|treated_unit x post    |                 |                   |-1.953. (0.9467) |                   |
|Population weights     |                 |                   |                 |Yes                |
|Heterogeneous trends   |                 |Yes                |Yes              |Yes                |
|Treated municipalities |10               |10                 |10               |10                 |
|Control municipalities |50               |50                 |26               |50                 |
|Fixed-Effects:         |---------------- |------------------ |---------------- |------------------ |
|municipality           |Yes              |Yes                |No               |Yes                |
|date                   |Yes              |Yes                |Yes              |Yes                |
|match_id               |No               |No                 |Yes              |No                 |
|______________________ |________________ |__________________ |________________ |__________________ |
|S.E.: Clustered        |by: municipality |by: municipality   |by: match_id     |by: municipality   |
|Observations           |4,320            |4,320              |4,248            |4,320              |
|R2                     |0.92185          |0.93375            |0.62985          |0.96875            |
|Dep. Var. mean         |1.6693           |1.6693             |1.7855           |1.6693             |
|RMSE                   |0.64842          |0.59704            |1.6034           |0.05873            |
