NexmoRequestListener<NexmoUser> listener = new NexmoRequestListener<NexmoUser>() {

    @Override
    public void onError(NexmoApiError nexmoApiError) {
        //Handle error
    }

    @Override
    public void onSuccess(NexmoUser nexmoUser) {
        //Handle success, and save the logged in NexmoUser
    }
};

NexmoClient.get().login(token, listener);
