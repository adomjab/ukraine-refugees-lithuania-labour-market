|                       |model 1          |model 2         |model 3          |model 4          |
|:----------------------|:----------------|:---------------|:----------------|:----------------|
|Dependent Var.:        |share_ua         |share_ua        |share_ua         |share_ua         |
|                       |                 |                |                 |                 |
|treat2 x post          |0.1732* (0.0782) |0.0381 (0.0768) |                 |-0.0320 (0.0677) |
|treated_unit x post    |                 |                |0.2870* (0.0956) |                 |
|Population weights     |                 |                |                 |Yes              |
|Heterogeneous trends   |                 |Yes             |Yes              |Yes              |
|Treated municipalities |7                |7               |10               |7                |
|Control municipalities |53               |53              |26               |53               |
|Fixed-Effects:         |---------------- |--------------- |---------------- |---------------- |
|municipality           |Yes              |Yes             |No               |Yes              |
|date                   |Yes              |Yes             |Yes              |Yes              |
|match_id               |No               |No              |Yes              |No               |
|______________________ |________________ |_______________ |________________ |________________ |
|S.E.: Clustered        |by: municipality |by: municipal.. |by: match_id     |by: municipality |
|Observations           |4,320            |4,320           |4,248            |4,320            |
|R2                     |0.75280          |0.86946         |0.86385          |0.94086          |
|Dep. Var. mean         |0.38097          |0.38097         |0.41842          |0.38097          |
|RMSE                   |0.22590          |0.16416         |0.16676          |0.01487          |
