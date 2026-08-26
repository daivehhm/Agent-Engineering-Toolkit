# Test Integrity Contract v1.5
测试是 Contract 的可执行 oracle，不是“让 CI 绿”的装饰。

## Forbidden

不得仅为了让实现 PASS：

- 删除失败测试；
- 把 assertion 改弱；
- 把失败测试永久 skip；
- 改 fixture 让错误路径消失；
- hardcode 当前实现输出作为 expected；
- 用 synthetic object 冒充真实 runtime path proof。

## When test changes are legitimate

只有当：

```text
Business / Contract semantic changed
```

且 Contract Impact Check 明确指出旧 test oracle 已过时，才可以更新 expectation。

必须同时说明：

```text
old semantic
new semantic
old test
why obsolete
new regression oracle
```

## Required separation

```text
Unit / Invariant Test
Path Integration Test
Real Runtime Evidence
```

三者不能互相冒充。

## Runner Authority

正式测试状态来自：

```text
raw runner result
exit code
failure count
error count
```

Narrative summary 不能覆盖 raw result。
