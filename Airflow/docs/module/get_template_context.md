> Version - 3.3.0

# 1. airflow.models.taskinstance

## A. 공식 Document

오늘은 날이 아닌듯

## B. Source Code

### a. context의 인자들

```python

return {  
    'conf': conf,  
    'dag': task.dag,  
    'dag_run': dag_run,  
    'ds': ds,  
    'ds_nodash': ds_nodash,  
    'execution_date': pendulum.instance(self.execution_date),  
    'inlets': task.inlets,  
    'macros': macros,  
    'next_ds': next_ds,  
    'next_ds_nodash': next_ds_nodash,  
    'next_execution_date': next_execution_date,  
    'outlets': task.outlets,  
    'params': params,  
    'prev_ds': prev_ds,  
    'prev_ds_nodash': prev_ds_nodash,  
    'prev_execution_date': prev_execution_date,  
    'prev_execution_date_success': lazy_object_proxy.Proxy(  
        lambda: self.get_previous_execution_date(state=State.SUCCESS)  
    ),  
    'prev_start_date_success': lazy_object_proxy.Proxy(  
        lambda: self.get_previous_start_date(state=State.SUCCESS)  
    ),  
    'run_id': run_id,  
    'task': task,  
    'task_instance': self,  
    'task_instance_key_str': ti_key_str,  
    'test_mode': self.test_mode,  
    'ti': self,  
    'tomorrow_ds': tomorrow_ds,  
    'tomorrow_ds_nodash': tomorrow_ds_nodash,  
    'ts': ts,  
    'ts_nodash': ts_nodash,  
    'ts_nodash_with_tz': ts_nodash_with_tz,  
    'var': {  
        'json': VariableJsonAccessor(),  
        'value': VariableAccessor(),  
    },  
    'yesterday_ds': yesterday_ds,  
    'yesterday_ds_nodash': yesterday_ds_nodash,  
}

```
