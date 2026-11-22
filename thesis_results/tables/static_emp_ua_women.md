|                       |model 1         |model 2         |model 3         |model 4          |
|:----------------------|:---------------|:---------------|:---------------|:----------------|
|Dependent Var.:        |emp_rate_ua     |emp_rate_ua     |emp_rate_ua     |emp_rate_ua      |
|                       |                |                |                |                 |
|treat x post           |0.0074 (0.0137) |0.0199 (0.0190) |                |0.0278. (0.0151) |
|treated_unit x post    |                |                |0.0108 (0.0173) |                 |
|Population weights     |                |                |                |Yes              |
|Heterogeneous trends   |                |Yes             |Yes             |Yes              |
|Treated municipalities |10              |10              |10              |10               |
|Control municipalities |50              |50              |26              |50               |
|Fixed-Effects:         |--------------- |--------------- |--------------- |---------------- |
|municipality           |Yes             |Yes             |No              |Yes              |
|date                   |Yes             |Yes             |Yes             |Yes              |
|match_id               |No              |No              |Yes             |No               |
|______________________ |_______________ |_______________ |_______________ |________________ |
|S.E.: Clustered        |by: municipal.. |by: municipal.. |by: match_id    |by: municipality |
|Observations           |4,129           |4,129           |4,159           |4,129            |
|R2                     |0.33140         |0.34281         |0.41312         |0.63192          |
|Dep. Var. mean         |0.87264         |0.87264         |0.87625         |0.87264          |
|RMSE                   |0.13294         |0.13180         |0.11012         |0.00917          |
