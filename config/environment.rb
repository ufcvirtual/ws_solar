# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
WsSolar::Application.initialize!

# constantes de status de matricula e pedido de matricula - table ALLOCATIONS
Allocation_Pending   = 0           # quando pede alocação(matricula) pela 1a vez
Allocation_Activated = 1           # com alocação ativa
Allocation_Cancelled = 2           # com alocação cancelada
Allocation_Pending_Reactivate = 3  # quando pede alocação(matricula) depois de ter sido cancelado

# Tipos de perfil
Profile_Type_No_Type            = 0
Profile_Type_Basic              = 0b00000001  # (1o bit = 1)
Profile_Type_Class_Responsible  = 0b00000010  # (2o bit = 1)
Profile_Type_Student            = 0b00000100  # (3o bit = 1)
