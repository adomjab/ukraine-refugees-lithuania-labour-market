|                       |model 1          |model 2           |model 3          |model 4          |
|:----------------------|:----------------|:-----------------|:----------------|:----------------|
|Dependent Var.:        |emp_rate_ltu     |emp_rate_ltu      |emp_rate_ltu     |emp_rate_ltu     |
|                       |                 |                  |                 |                 |
|treat x post           |-0.0009 (0.0012) |-0.0023* (0.0011) |                 |-0.0012 (0.0007) |
|treated_unit x post    |                 |                  |-0.0043 (0.0027) |                 |
|Population weights     |                 |                  |                 |Yes              |
|Heterogeneous trends   |                 |Yes               |Yes              |Yes              |
|Treated municipalities |10               |10                |10               |10               |
|Control municipalities |50               |50                |26               |50               |
|Fixed-Effects:         |---------------- |----------------- |---------------- |---------------- |
|municipality           |Yes              |Yes               |No               |Yes              |
|date                   |Yes              |Yes               |Yes              |Yes              |
|match_id               |No               |No                |Yes              |No               |
|______________________ |________________ |_________________ |________________ |________________ |
|S.E.: Clustered        |by: municipality |by: municipality  |by: match_id     |by: municipality |
|Observations           |4,320            |4,320             |4,248            |4,320            |
|R2                     |0.66470          |0.67205           |0.55671          |0.79623          |
|Dep. Var. mean         |0.94562          |0.94562           |0.94425          |0.94562          |
|RMSE                   |0.00841          |0.00832           |0.01093          |0.00063          |
