from azureml.core import Workspace
from azureml.core.compute import ComputeTarget, ComputeTargetException
from azureml.core.compute import AmlCompute

# Configuración del espacio de trabajo
workspace = Workspace.from_config()  # Carga la configuración desde el archivo config.json

# Parámetros de la máquina virtual
vm_name = "mi-maquina-virtual"
vm_resource_group = "mi-grupo-de-recursos"

# Intentar adjuntar la máquina virtual
try:
    compute_target = ComputeTarget.attach(workspace, vm_name)
    compute_target.wait_for_completion(show_output=True)
    print(f"Máquina virtual '{vm_name}' conectada exitosamente al espacio de trabajo.")
except ComputeTargetException as e:
    print(f"Error al conectar la máquina virtual: {e}")