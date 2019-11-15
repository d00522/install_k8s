apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: kube-system
  labels:
    k8s-app: node-exporter
    kubernetes.io/cluster-service: "true"
    addonmanager.kubernetes.io/mode: Reconcile
    version: v0.18.1
spec:
  selector:
    matchLabels:
      k8s-app: node-exporter
      version: v0.18.1
  updateStrategy:
    type: OnDelete
  template:
    metadata:
      labels:
        k8s-app: node-exporter
        version: v0.18.1
    spec:
      priorityClassName: system-node-critical
      containers:
        - name: prometheus-node-exporter
          image: "PRI_DOCKER_HOST:5000/prom/node-exporter:v0.18.1"
          imagePullPolicy: "IfNotPresent"
          args:
            - --path.procfs=/host/proc
            - --path.sysfs=/host/sys
          ports:
            - name: metrics
              containerPort: 9100
              hostPort: 9100
          volumeMounts:
            - name: proc
              mountPath: /host/proc
              readOnly:  true
            - name: sys
              mountPath: /host/sys
              readOnly: true
          resources:
            limits:
              memory: 50Mi
            requests:
              cpu: 100m
              memory: 50Mi
      hostNetwork: true
      hostPID: true
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
