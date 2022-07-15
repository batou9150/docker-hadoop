# [Livy](https://livy.incubator.apache.org/)

A REST Service for Apache Spark

Livy
* `CONFIG_LIVY_BIND_HOST` : Server listens on this address. (default "0.0.0.0")
* `CONFIG_LIVY_PORT` : Server listens on this port. (default "8998")
* `CONFIG_LIVY_BASEPATH` : Base path ui should work on. (default "/")
* `CONFIG_LIVY_ENABLE_HIVE_CONTEXT` : Whether to enable HiveContext in livy interpreter (default "false")
* `CONFIG_LIVY_LOCAL_DIR_WHITELIST` :  List of local directories from where files are allowed to be added to user sessions. (Optional)

Spark
* `CONFIG_SPARK_MASTER` : The Spark Master (default "yarn")
* `CONFIG_SPARK_DEPLOY_MODE` : The Spark Deploy Mode : "cluster" or "client" (default "cluster")
