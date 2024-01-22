apiVersion: apps/v1
kind: Deployment
metadata:
  name: checkoutservice
  labels: 
    app: checkoutservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: checkoutservice
  template:
    metadata:
      labels:
        app: checkoutservice
    spec:
      containers:
      - name: checkoutservice
        image: gcr.io/GOOGLE_CLOUD_PROJECT/checkoutservice:COMMIT_SHA
        env:
        - name: PRODUCT_CATALOG_SERVICE_ADDR
          value: "productcatalogservice:3550"
        - name: SHIPPING_SERVICE_ADDR
          value: "shippingservice:50051"
        - name: CART_SERVICE_ADDR
          value: "cartservice:7070"
        - name: CURRENCY_SERVICE_ADDR
          value: "currencyservice:7000"
        - name: EMAIL_SERVICE_ADDR
          value: "emailservice:5000"
        - name: PAYMENT_SERVICE_ADDR
          value: "paymentservice:50052"
        ports:
        - containerPort: 5050
---
kind: Service
apiVersion: v1
metadata:
  name: checkoutservice
spec:
  selector:
    app: checkoutservice
  ports:
  - protocol: TCP
    port: 5050
    targetPort: 5050
  type: ClusterIP