List<String> userIdsToCall = ... ;
NexmoIRequestListener<NexmoCall> listener = new NexmoRequestListener<NexmoCall>() {

    @Override
    public void onError(NexmoApiError nexmoApiError) {
        //Handle error
    }

    @Override
    public void onSuccess(NexmoCall nexmoCall) {
        //Handle success
    }
};

NexmoClient.get().call(userIdsToCall, listener);
