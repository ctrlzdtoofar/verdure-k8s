#  📖 Runbook: DB Problems

_Note: Docker Desktop does not have a straight forward mechanism to 
persist db data within k8s. Back up any db data you don't want to lose.

## 🧑‍🚒 Inquiry Steps 

### 1. Check Persistent Volume Claims (PVCs):
Verify that your PVCs are still bound and that the Persistent Volumes (PVs) they claim are still available.

```zsh
kubectl get pvc

NAME               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
postgres-pvc       Bound    pvc-fc7b93be-feb7-4cfc-9fcc-1a5c2b055b9c   10Gi       RWO            hostpath       <unset>                 6d16h
tst-postgres-pvc   Bound    pvc-c9e134ba-e90b-4124-8455-b0ebe28e68e0   1Gi        RWO            hostpath       <unset>                 3d20h
```

### 2. Inspect Persistent Volumes (PVs):
Look at the status of the PVs to see if they are still bound to the PVCs and check for any status conditions that indicate issues.

```zsh
kubectl get pv

NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pvc-c9e134ba-e90b-4124-8455-b0ebe28e68e0   1Gi        RWO            Delete           Bound    default/tst-postgres-pvc   hostpath       <unset>                          3d20h
pvc-fc7b93be-feb7-4cfc-9fcc-1a5c2b055b9c   10Gi       RWO            Delete           Bound    default/postgres-pvc       hostpath       <unset>                          6d16h
```

### 3. Database Pod Status:
Check the status of your database pods. If the pods were restarted, there might be clues in the events or logs.

```zsh
kubectl get pods
postgres-deployment-8f77799b5-rl8rf         1/1     Running            1 (7h16m ago)   5d22h

kubectl describe pod <db-pod-name>
kubectl describe pod postgres-deployment-8f77799b5-rl8rf 

kubectl logs <db-pod-name>
```

### 4. Data Integrity:
If the pods are running and the volumes are bound correctly, there may have been an issue with the database itself. For instance, if the database wasn't shut down cleanly, it could have led to data inconsistency or loss.

### 5. Volume Data:
If you have access to the underlying node and storage, you can manually inspect the volume data to ensure it's intact. For cloud environments, you can check the cloud console for the state of the disks.

### 6. Backup and Recovery:
Check if you have backups and recovery procedures in place. Sometimes, Kubernetes resources like PVs and PVCs can be recreated by the system if they were not set up with the right storage class or reclaim policy, leading to data loss. Always ensure you have a backup policy in place.

### 7. Reclaim Policy:
Check the Reclaim Policy of your PVs. If set to 'Delete', the data would be lost when the PVC is deleted.

```zsh
kubectl get pvc
kubectl describe pv <persistent-volume-name>

kubectl describe pv pvc-fc7b93be-feb7-4cfc-9fcc-1a5c2b055b9c 
Claim:           default/postgres-pvc
Reclaim Policy:  Delete
```

### 8. Storage Class:
Inspect the storage class to see if it has a reclaimPolicy set to Retain or Delete. A Delete reclaim policy means the underlying storage would be deleted along with the PV.

```zsh
kubectl get sc
```

### 9. Kubernetes Events:
Look at the Kubernetes events to see if there were any issues during the restart.

```zsh
kubectl get events --sort-by='.metadata.creationTimestamp'
```
### 10. Review Configuration:
Ensure your database stateful applications are using StatefulSets if applicable, which are designed for this type of workload. Check that the deployment configuration matches the requirements for persistent storage.

### 11. Contact Cloud Provider Support:
If your cluster is managed by a cloud provider and the above steps don't yield answers, contacting their support team may provide additional insights.

## 💡 Remediation 

Some helpful steps to take. Nothing specific. 

### Rerun the db init job
```zsh
 kubectl delete job db-init-job
 kubectl apply -f postgres-init-job.yaml
```

### Delete the dev db (Destructive)
```zsh
kubectl delete deployment postgres-deployment
kubectl delete job db-init-job
kubectl delete pvc postgres-pvc
kubectl get pv
kubectl delete pv <name>
kubectl delete sc hostpath-retained-sc

kubectl delete deployment tst-postgres-deployment
kubectl delete job tst-db-init-job
kubectl delete pvc tst-postgres-pvc
kubectl delete pv <name>
kubectl delete sc tst-hostpath-retained-sc
```

#### Reapply the k8s kinds with new StorageClass kinds with provisioner reclaim policies set to `Retain`
```zsh
kubectl apply -f postgres-pvc.yaml
kubectl apply -f postgres.yaml
kubectl apply -f postgres-init-job.yaml

kubectl apply -f tst-postgres-pvc.yaml
kubectl apply -f tst-postgres.yaml
kubectl apply -f tst-postgres-init-job.yaml

# Restart the port-forwarding
pkill -f "kubectl port-forward"
nohup kubectl port-forward service/postgres-cluster-ip-service 5432:5432 > port-forward.log 2>&1 &
nohup kubectl port-forward service/tst-postgres-cluster-ip-service 5433:5433 > tst-port-forward.log 2>&1 &
```
_Note: once the database if back online, the Go app Translations, if still running, will auto create the audit and fixit tables since it uses gorm. This won't hurt anything._

#### Reload the Dev database from backup
I use DataGrip for this locally.

a. Right click on DataSource

b. Select Import/Export > Restore with 'psql'

c. Set where to find psql, in my case: /opt/homebrew/opt/libpq/bin/psql

d. Set the path to the most recent backup: "postgres_localhost_ROOT-<recent-date>-dump.sql"

e. Run

-Or-
```zsh
psql --file=postgres_localhost_ROOT-<recent-date>-dump.sql --username=postgres --host=localhost --port=5432
```
_Note: you may need to provide the password._
```zsh
psql --file=postgres_localhost_ROOT-<recent-date>-dump.sql --username=postgres --host=localhost --port=5432 --password
```

### If the schema was changed since the last backup, either restart palabras or re-run the Rust Diesel Migration manually.
Reference the [Palabras project](https://github.com/heather92115/palabras/blob/main/docs/db.md) to complete this step.
