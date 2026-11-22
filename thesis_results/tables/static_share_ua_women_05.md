|                       |model 1          |model 2         |model 3          |model 4         |
|:----------------------|:----------------|:---------------|:----------------|:---------------|
|Dependent Var.:        |share_ua         |share_ua        |share_ua         |share_ua        |
|                       |                 |                |                 |                |
|treat05 x post         |0.2738* (0.1041) |0.1251 (0.0912) |                 |0.1104 (0.0975) |
|treated_unit x post    |                 |                |0.2870* (0.0956) |                |
|Population weights     |                 |                |                 |Yes             |
|Heterogeneous trends   |                 |Yes             |Yes              |Yes             |
|Treated municipalities |15               |15              |10               |15              |
|Control municipalities |45               |45              |26               |45              |
|Fixed-Effects:         |---------------- |--------------- |---------------- |--------------- |
|municipality           |Yes              |Yes             |No               |Yes             |
|date                   |Yes              |Yes             |Yes              |Yes             |
|match_id               |No               |No              |Yes              |No              |
|______________________ |________________ |_______________ |________________ |_______________ |
|S.E.: Clustered        |by: municipality |by: municipal.. |by: match_id     |by: municipal.. |
|Observations           |4,320            |4,320           |4,248            |4,320           |
|R2                     |0.76604          |0.87158         |0.86385          |0.94189         |
|Dep. Var. mean         |0.38097          |0.38097         |0.41842          |0.38097         |
|RMSE                   |0.21977          |0.16282         |0.16676          |0.01474         |
