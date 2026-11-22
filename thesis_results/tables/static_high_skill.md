|                       |model 1          |model 2          |model 3          |model 4          |
|:----------------------|:----------------|:----------------|:----------------|:----------------|
|Dependent Var.:        |high_skill       |high_skill       |high_skill       |high_skill       |
|                       |                 |                 |                 |                 |
|treat x post           |0.0067* (0.0030) |0.0067* (0.0030) |                 |0.0044* (0.0020) |
|treated_unit x post    |                 |                 |-0.0197 (0.0133) |                 |
|Population weights     |                 |                 |                 |Yes              |
|Heterogeneous trends   |                 |Yes              |Yes              |Yes              |
|Treated municipalities |10               |10               |10               |10               |
|Control municipalities |50               |50               |26               |50               |
|Fixed-Effects:         |---------------- |---------------- |---------------- |---------------- |
|municipality           |Yes              |Yes              |No               |Yes              |
|date                   |Yes              |Yes              |Yes              |Yes              |
|match_id               |No               |No               |Yes              |No               |
|______________________ |________________ |________________ |________________ |________________ |
|S.E.: Clustered        |by: municipality |by: municipality |by: match_id     |by: municipality |
|Observations           |4,320            |4,320            |4,248            |4,320            |
|R2                     |0.94523          |0.95661          |0.79871          |0.99411          |
|Dep. Var. mean         |0.36385          |0.36385          |0.35454          |0.36385          |
|RMSE                   |0.01000          |0.00890          |0.02002          |0.00070          |
