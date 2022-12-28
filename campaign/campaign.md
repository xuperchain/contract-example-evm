#### 场景介绍

campaign 合约，实现场景为学生会主席竞选流程。

#### 流程介绍

1. 合约初始化时，指定具有owner权限的账户，该账户具有检票与提名候选人以及启动竞选提案的权利。
2. 启动竞选提案，需要提名一位候选人，并指定提案通过票数阈值，更新提案状态为投票中，返回该次提案ID。
3. 任何人都可以根据提案ID查询该提案的状态。
4. 当提案状态为投票中，任何人可以调用投票功能进行投票，限投一人一票，重复投票不会生效。
5. 当票数大于启动提案时设置的阈值，提案状态为待检票，owner 可启动检票。
6. 检票会进行身份验证，只有owner账户可以成功调用。
7. 检票通过后，提案流程结束，提案状态置为已生效，此时任何人都可以查询当前学生会主席信息。
8. 当提案状态为未启动、已生效、待检票时，不可使用投票功能。
9. 任何人都可根据提案ID查询该提案的候选人信息。

#### 功能介绍

##### constructor

- Params:
  - owner:
    - type: address
    - desc: owner权限设置
- Desc: 设置owner权限账户，初始化提案状态

##### propose

- Params:
  - candidate:
    - type: string
    - desc: 候选人
  - target:
    - type: uint256
    - desc: 票数阈值
- Returns: 
  - proposalId:
    - type: uint256
    - desc: 提案ID
- Desc: 启动竞选提案

##### queryProposal

- Params:
  - proposalId:
    - type: uint256
    - desc: 提案ID

- Returns:
  - status:
    - type: string
    - desc: 提案状态：未启动(stoped)、投票中(voting)、待检票(passed)、已生效(completed)
- Desc: 查询提案状态

##### vote

- Params:
  - proposalId:
    - type: uint256
    - desc: 提案ID

- Retruns:
  - status:
    - type: string
    - desc: 投票状态："success" or "error"，error需给出原因
- Desc: 进行投票，调用该方法，视为调用者进行投票一次

##### queryVotes

- Params:
  - proposalId:
    - type: uint256
    - desc: 提案ID

- Returns:
  - votes:
    - type: uint256
    - desc: 当前所获票数，当状态为未启动时，应为0
- Desc: 查询已经获取的票数

##### check

- Params:
  - proposalId:
    - type: uint256
    - desc: 提案ID

- Returns:
  - status:
    - type: string
    - desc: 检票状态："success" or "error"，error需给出原因
- Desc: 启动检票

##### queryPresident

- Returns:
  - president:
    - type: string
    - desc: 竞选成功的候选人
- Desc: 查询学生会主席信息

##### queryCandidate

- Params:
  - proposalId: 
    - type: uint256
    - desc: 提案ID
- Returns:
  - candidate:
    - type: string
    - desc: 提案候选人信息
- Desc: 查询提案候选人信息