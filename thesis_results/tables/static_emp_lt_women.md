|                       |model 1          |model 2          |model 3         |model 4          |
|:----------------------|:----------------|:----------------|:---------------|:----------------|
|Dependent Var.:        |emp_rate_ltu     |emp_rate_ltu     |emp_rate_ltu    |emp_rate_ltu     |
|                       |                 |                 |                |                 |
|treat x post           |0.0015. (0.0008) |-0.0002 (0.0009) |                |-0.0007 (0.0005) |
|treated_unit x post    |                 |                 |0.0002 (0.0037) |                 |
|Population weights     |                 |                 |                |Yes              |
|Heterogeneous trends   |                 |Yes              |Yes             |Yes              |
|Treated municipalities |10               |10               |10              |10               |
|Control municipalities |50               |50               |26              |50               |
|Fixed-Effects:         |---------------- |---------------- |--------------- |---------------- |
|municipality           |Yes              |Yes              |No              |Yes              |
|date                   |Yes              |Yes              |Yes             |Yes              |
|match_id               |No               |No               |Yes             |No               |
|______________________ |________________ |________________ |_______________ |________________ |
|S.E.: Clustered        |by: municipality |by: municipality |by: match_id    |by: municipality |
|Observations           |4,320            |4,320            |4,248           |4,320            |
|R2                     |0.74536          |0.74809          |0.63140         |0.79017          |
|Dep. Var. mean         |0.96204          |0.96204          |0.95911         |0.96204          |
|RMSE                   |0.00961          |0.00956          |0.01481         |0.00076          |
