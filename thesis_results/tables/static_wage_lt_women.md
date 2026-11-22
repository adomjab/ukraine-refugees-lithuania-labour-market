|                       |model 1          |model 2         |model 3            |model 4         |
|:----------------------|:----------------|:---------------|:------------------|:---------------|
|Dependent Var.:        |log_real_lt      |log_real_lt     |log_real_lt        |log_real_lt     |
|                       |                 |                |                   |                |
|treat x post           |-0.0008 (0.0049) |0.0025 (0.0056) |                   |0.0067 (0.0057) |
|treated_unit x post    |                 |                |-0.0565** (0.0172) |                |
|Population weights     |                 |                |                   |Yes             |
|Heterogeneous trends   |                 |Yes             |Yes                |Yes             |
|Treated municipalities |10               |10              |10                 |10              |
|Control municipalities |50               |50              |26                 |50              |
|Fixed-Effects:         |---------------- |--------------- |------------------ |--------------- |
|municipality           |Yes              |Yes             |No                 |Yes             |
|date                   |Yes              |Yes             |Yes                |Yes             |
|match_id               |No               |No              |Yes                |No              |
|______________________ |________________ |_______________ |__________________ |_______________ |
|S.E.: Clustered        |by: municipality |by: municipal.. |by: match_id       |by: municipal.. |
|Observations           |4,320            |4,320           |4,248              |4,320           |
|R2                     |0.95765          |0.96003         |0.87003            |0.98817         |
|Dep. Var. mean         |2.5198           |2.5198          |2.5300             |2.5198          |
|RMSE                   |0.02467          |0.02397         |0.04285            |0.00230         |
