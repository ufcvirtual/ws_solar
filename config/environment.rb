# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
WsSolar::Application.initialize!

# constantes de status de matricula e pedido de matricula - table ALLOCATIONS
Allocation_Pending   = 0           # quando pede alocação(matricula) pela 1a vez
Allocation_Activated = 1           # com alocação ativa
Allocation_Cancelled = 2           # com alocação cancelada
Allocation_Pending_Reactivate = 3  # quando pede alocação(matricula) depois de ter sido cancelado
