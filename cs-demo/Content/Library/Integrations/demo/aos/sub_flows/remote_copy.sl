namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.102
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/order/target/order.war'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        publish:
          - output_0: output_0
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_host: '${filename}'
            - destination_host: '${host}'
            - destination_path: /tmp
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 73
        y: 69
      get_file:
        x: 77
        y: 221
      remote_secure_copy:
        x: 76
        y: 368
        navigate:
          b8b82c2f-c6a2-ae90-07e4-e0a2c92849e9:
            targetId: ccf676e5-edd7-7ca8-2534-270115eb3d84
            port: SUCCESS
    results:
      SUCCESS:
        ccf676e5-edd7-7ca8-2534-270115eb3d84:
          x: 255
          y: 369
