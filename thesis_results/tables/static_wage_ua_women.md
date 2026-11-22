|                       |model 1          |model 2          |model 3          |model 4          |
|:----------------------|:----------------|:----------------|:----------------|:----------------|
|Dependent Var.:        |log_real_ua      |log_real_ua      |log_real_ua      |log_real_ua      |
|                       |                 |                 |                 |                 |
|treat x post           |-0.0266 (0.0489) |-0.0040 (0.0647) |                 |-0.0019 (0.0453) |
|treated_unit x post    |                 |                 |-0.0143 (0.0510) |                 |
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
|Observations           |4,093            |4,093            |4,147            |4,093            |
|R2                     |0.43544          |0.46218          |0.24781          |0.64587          |
|Dep. Var. mean         |2.3445           |2.3445           |2.3629           |2.3445           |
|RMSE                   |0.23320          |0.22761          |0.21466          |0.01627          |
