const conversationClient = new ConversationClient({ debug: false });
conversationClient.login(userToken).then(application => {
    //Handle the logged in application
});
