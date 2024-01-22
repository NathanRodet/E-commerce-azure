apiVersion: apps/v1
kind: Deployment
metadata:
  name: cartservice
  labels: 
    app: cartservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cartservice
  template:
    metadata:
      labels:
        app: cartservice
    spec:
      containers:
      - name: cartservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/cartservice:COMMIT_SHA
        env:
        - name: REDIS_ADDR
          value: "ubuntu-redis.europe-west3-a.c.formationgcp-jordan.internal:6379" # /!\ valeur à changer
        ports:
        - containerPort: 7070
---
kind: Service
apiVersion: v1
metadata:
  name: cartservice
spec:
  selector:
    app: cartservice
  ports:
  - protocol: TCP
    port: 7070
    targetPort: 7070
  type: ClusterIP