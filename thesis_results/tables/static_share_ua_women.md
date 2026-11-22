|                       |model 1           |model 2          |model 3          |model 4          |
|:----------------------|:-----------------|:----------------|:----------------|:----------------|
|Dependent Var.:        |share_ua          |share_ua         |share_ua         |share_ua         |
|                       |                  |                 |                 |                 |
|treat x post           |0.3279** (0.0990) |0.1789. (0.0940) |                 |0.1601. (0.0877) |
|treated_unit x post    |                  |                 |0.2870* (0.0956) |                 |
|Population weights     |                  |                 |                 |Yes              |
|Heterogeneous trends   |                  |Yes              |Yes              |Yes              |
|Treated municipalities |10                |10               |10               |10               |
|Control municipalities |50                |50               |26               |50               |
|Fixed-Effects:         |----------------- |---------------- |---------------- |---------------- |
|municipality           |Yes               |Yes              |No               |Yes              |
|date                   |Yes               |Yes              |Yes              |Yes              |
|match_id               |No                |No               |Yes              |No               |
|______________________ |_________________ |________________ |________________ |________________ |
|S.E.: Clustered        |by: municipality  |by: municipality |by: match_id     |by: municipality |
|Observations           |4,320             |4,320            |4,248            |4,320            |
|R2                     |0.76709           |0.87256          |0.86385          |0.94321          |
|Dep. Var. mean         |0.38097           |0.38097          |0.41842          |0.38097          |
|RMSE                   |0.21927           |0.16220          |0.16676          |0.01457          |
