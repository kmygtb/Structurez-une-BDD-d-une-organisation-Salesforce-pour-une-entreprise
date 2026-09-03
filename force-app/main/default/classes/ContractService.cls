public with sharing class ContractService {

    private static final String STATUS_DRAFT = 'Draft';
    private static final String STATUS_ACTIVATED = 'Activated';

    public static Contract createContract(Contract newContract) {
        if (!Schema.sObjectType.Contract.isCreateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de créer un contrat.');
        }
        newContract.Status = STATUS_DRAFT;
        System.debug('ContractService : creation d\'un contrat : ' + newContract.Name);
        insert newContract;
        return newContract;
    }

    public static void activateContract(Id contractId) {
        if (!Schema.sObjectType.Contract.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier ce contrat.');
        }
        System.debug('ContractService : activation du contrat : ' + contractId);
        update new Contract(Id = contractId, Status = STATUS_ACTIVATED);
    }

    public static void updateContract(Contract contractToUpdate) {
        if (!Schema.sObjectType.Contract.isUpdateable()) {
            throw new SecurityException('Vous n\'avez pas le droit de modifier ce contrat.');
        }
        System.debug('ContractService : mise à jour du contrat : ' + contractToUpdate.Name);
        update contractToUpdate;
    }

    public static void deleteContract(Id contractId) {
        if (!Schema.sObjectType.Contract.isDeletable()) {
            throw new SecurityException('Vous n\'avez pas le droit de supprimer ce contrat.');
        }
        System.debug('ContractService : suppression du contrat : ' + contractId);
        delete new Contract(Id = contractId);
    }
}