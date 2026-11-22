|                       |model 1           |model 2           |model 3            |model 4          |
|:----------------------|:-----------------|:-----------------|:------------------|:----------------|
|Dependent Var.:        |log_real_lt       |log_real_lt       |log_real_lt        |log_real_lt      |
|                       |                  |                  |                   |                 |
|treat x post           |-0.0209. (0.0122) |-0.0153. (0.0091) |                   |-0.0032 (0.0067) |
|treated_unit x post    |                  |                  |-0.0990** (0.0301) |                 |
|Population weights     |                  |                  |                   |Yes              |
|Heterogeneous trends   |                  |Yes               |Yes                |Yes              |
|Treated municipalities |10                |10                |10                 |10               |
|Control municipalities |50                |50                |26                 |50               |
|Fixed-Effects:         |----------------- |----------------- |------------------ |---------------- |
|municipality           |Yes               |Yes               |No                 |Yes              |
|date                   |Yes               |Yes               |Yes                |Yes              |
|match_id               |No                |No                |Yes                |No               |
|______________________ |_________________ |_________________ |__________________ |________________ |
|S.E.: Clustered        |by: municipality  |by: municipality  |by: match_id       |by: municipality |
|Observations           |4,320             |4,320             |4,248              |4,320            |
|R2                     |0.96206           |0.96823           |0.77708            |0.98939          |
|Dep. Var. mean         |2.5712            |2.5712            |2.5865             |2.5712           |
|RMSE                   |0.03367           |0.03081           |0.08320            |0.00291          |
