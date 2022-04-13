> Version - 3.3.0

# 1. airflow.providers.amazon.aws.hooks.s3

## A. 공식 Document



## B. Source Code

### a. Method

#### load_file

```python

@provide_bucket_name
@unify_bucket_name_and_key
def load_file(
	self,
	filename: Union[Path, str],
	key: str,
	bucket_name: Optional[str] = None,
	replace: bool = False,
	encrypt: bool = False,
	gzip: bool = False,
	acl_policy: Optional[str] = None,
) -> None:
	
	filename = str(filename)
	if not replace and self.check_for_key(key, bucket_name):
		raise ValueError(f"The key {key} already exists.")

	extra_args = self.extra_args
	if encrypt:
		extra_args['ServerSideEncryption'] = "AES256"
	if gzip:
		with open(filename, 'rb') as f_in:
			filename_gz = f_in.name + '.gz'
			with gz.open(filename_gz, 'wb') as f_out:
				shutil.copyfileobj(f_in, f_out)
				filename = filename_gz
	if acl_policy:
		extra_args['ACL'] = acl_policy

	client = self.get_conn()
	client.upload_file(filename, bucket_name, key, ExtraArgs=extra_args, Config=self.transfer_config)
		
```

- 이미 `동일한 key를 갖는 bucket이 있거`나 replace를 지정해주지 않아서 `False`이면 에러를 발생시킨다.