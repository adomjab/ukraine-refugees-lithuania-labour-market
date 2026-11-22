|                       |model 1           |model 2           |model 3         |model 4         |
|:----------------------|:-----------------|:-----------------|:---------------|:---------------|
|Dependent Var.:        |servsales         |servsales         |servsales       |servsales       |
|                       |                  |                  |                |                |
|treat x post           |-0.0032. (0.0017) |-4.49e-5 (0.0021) |                |0.0015 (0.0011) |
|treated_unit x post    |                  |                  |0.0063 (0.0085) |                |
|Population weights     |                  |                  |                |Yes             |
|Heterogeneous trends   |                  |Yes               |Yes             |Yes             |
|Treated municipalities |10                |10                |10              |10              |
|Control municipalities |50                |50                |26              |50              |
|Fixed-Effects:         |----------------- |----------------- |--------------- |--------------- |
|municipality           |Yes               |Yes               |No              |Yes             |
|date                   |Yes               |Yes               |Yes             |Yes             |
|match_id               |No                |No                |Yes             |No              |
|______________________ |_________________ |_________________ |_______________ |_______________ |
|S.E.: Clustered        |by: municipality  |by: municipality  |by: match_id    |by: municipal.. |
|Observations           |4,320             |4,320             |4,248           |4,320           |
|R2                     |0.95656           |0.96180           |0.77696         |0.98877         |
|Dep. Var. mean         |0.11620           |0.11620           |0.11408         |0.11620         |
|RMSE                   |0.00709           |0.00665           |0.01869         |0.00046         |
