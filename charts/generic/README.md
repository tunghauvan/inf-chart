# DEPLOYMENT

## Using Helm Template

To use the Helm template in this repository, follow these steps:

1. Ensure you have Helm installed. You can download it from [Helm's official website](https://helm.sh/docs/intro/install/).

2. Clone this repository to your local machine.
    ```bash
    git clone https://github.com/galaxyed/deployment-template.git
    ```

3. Navigate to the root of the repository.
    ```bash
    cd deployment-template
    ```

4. Run the following command to render the Helm template.
    ```bash
    helm template . --output-dir ./output --values config.values.yaml --values secret.values.yaml
    ```

5. Review the rendered templates in the `./output` directory.

6. (Optional) To deploy the rendered templates to your Kubernetes cluster, use:
    ```bash
    kubectl apply -f ./output
    ```

7. Verify the deployment by checking the status of the resources:
    ```bash
    kubectl get all
    ```

8. (Optional) To clean up the deployed resources, use:
    ```bash
    kubectl delete -f ./output
    ```
