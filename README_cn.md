# goplay-unity3d-sdk

Version 1.0

## (Really) Quick-start Guide
This tutorial will go through the step-by-step instructions to integrate the Login feature to a Unity3d game project.

### Requirements
Unity3D version 4.6 or later
### Step 1: Import plugin
Open Unity Editor and double click package `GoPlaySDK_v1.XX.unitypackage` to import all necessary environment. 
Or you can choose `Assets > Import Package > Custom Package…` and choose `GoPlaySDK _v1.XX.unitypackage` location.
### Step 2: Determine to connect to which server
GoPlay provides dev server and production server. To setup the Live server build or Test server build, configure the Boolean variable `UseLiveServer` in `GoPlaySDK.cs`. Set it to `True` to use production server, `False` for dev server.
```c#
public bool UseLiveServer {get; set;}
```
### Step 3: Set up GAME_ID
To start using the SDK, we need to set up the `GAME_ID` of the current project. The value helps GoPlay server identify which game connecting to it.
Choose from Unity3D menu,  `GoPlaySDK > Setting` to open Setting Dialog.

![Unity3D Setting](https://raw.githubusercontent.com/gtoken/goplay-unity3d-sdk/master/unity_setting.png)
### Step 4: Call Login API and get a response
GoPlaySDK uses an Event subscription mechanism. Each API call is a HTTP asynchronous web request. When a response callback is available, an Event will be triggered. Client application can easily subscribe to these events.
```c#
GoPlaySdk.Instance.OnLogin += OnLogin;

void OnLogin(IResult callback)
{
  var result = callback as LoginResult;
  if (result != null)
  {
    // Yipee…
  }
}
```
For a full listing of the source code sample, please refer to the sample Unity project in the SDK package.

## API References
### Table of contents
1. [API Calls](#api_calls)
  1. [Login](#login)
  2. [Register](#register)
  3. [Logout](#logout)
  4. [Get Profile](#get_profile)
  5. [Edit Profile](#edit_profile)
  6. [Get Progress](#get_progress)
  7. [Save Progress](#save_progress)
  8. [Save Progress File](#save_progress_file)
  9. [Read Progress](#read_progress)
  10. [Update Game Stats](#update_game_stats)
  11. [Get Unfulfilled Exchanges](#get_unfulfilled_exchanges)
  12. [Fulfill Exchange](#fulfill_exchange)
  13. [Reject Exchange](#reject_exchange)
2. [Supporting Classes](#supporting_classes)
  1. [Session](#session)
  2. [UserProfile](#userprofile)
  3. [Exchange](#exchange)
  4. [GameStat](#game_stat)

### <a name='api_calls'></a>API Calls
#### <a name='login'></a>Login
```c#
public void Login(string userName, string password)
public void Login(SocialPlatforms platform, string token)
```
This method perform a log-in to GoPlaySDK using a username and password. A user account must be available before calling this method.
An event will be triggered when server callbacks. This event must be hooked up before calling this method.

If user login via facebook account, the server will bind the user with the facebook account for future auto-login.
```c#
Example:

GoPlaySdk.Instance.OnLogin+= HandleOnLogin;

GoPlaySdk.Instance.Login(Username.text, Password.text);
```
#####Input

| Paramter      | Type          | Notes              |
| ------------- |---------------| -------------------|
| username      | string        | Required parameter |
| password      | string        | Required parameter |

##### Output (LoginResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Session       | string        | Access token for late requests
| Profile       | `UserProfile` | See `UserProfile` definition in `Supporting Classes` section

##### Error Messages
* INVALID_USN_PWD - 'Username or Password is incorrect'
* MISSING_FIELDS - 'Required field(s) is blank'
* INVALID_GAME_ID - 'Invalid Game ID'

#### <a name='register'></a>Register
```c#
public void Register(string userName, string password, string email = null, string nickName = null, Gender gender = Gender.Other, string referal = null)
```
This method is used to explicitly register a new customer account. 
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

If user registers by using a facebook account, the server will bind the user with the facebook account for future auto-login.
```c#
Example:

GoPlaySdk.Instance.OnRegister += OnRegister;

GoPlaySdk.Instance.Register(Username.text,Password.text,Email.text);
```
#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| username      | string        | Required Parameter. Must be unique.
| password      | string        | Required parameter 
| email         | string        |
| nickName      | string        |
| gender        | string        | `male`, `female`, or `other`
| referral      | string        |

##### Output (RegisterResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Session       | string        | Access token for late requests
| Profile       | `UserProfile` | See `UserProfile` definition in `Supporting Classes` section

##### Error Messages
* EXISTING_USERNAME_EMAIL- 'Account with such username/email already exists'
* MISSING_FIELDS - 'Required field(s) is blank'
* INVALID_GAME_ID - 'Invalid Game ID'
* USERNAME_LENGTH - 'Username is between 3-20 characters'
* INVALID_USERNAME - 'Username does not accept special characters'
* PASSWORD_LENGTH - 'Password must be more than 3 characters'

#### <a name='logout'></a>Logout
This method logs out a player from GoPlay server.
```c#
Example:

GoPlaySdk.Instance.LogOut();
```
#### <a name='get_profile'></a>Get Profile
```c#
public void GetProfile()
```
Call this method to retrieve the profile of a user. 
An event will be triggered when server callbacks. This event must be hooked up before calling the API.
```c#
Example:

GoPlaySdk.Instance.OnGetProfile += HandleOnGetProfile

GoPlaySdk.Instance.GetProfile();
```
#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------

##### Output (profileResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Profile       | `UserProfile` | See `UserProfile` definition in `Supporting Classes` section

##### Error Messages
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’

#### <a name='edit_profile'></a>Edit Profile
```c#
public void EditProfile(string email=null, string nickName=null, Gender?  gender=null )
```
Call this method to updates the profile of a user. Parameters may be omitted, and those fields will be unchanged.
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

Example:
```c#
GoPlaySdk.Instance.OnEditProfile += HandleOnEditProfile;
GoPlaySdk.Instance.EditProfile(Email.text,NickName.text);
```
#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| email         | string        |
| nickName      | string        |
| gender        | string        | `male`, `female`, or `other`

##### Output (ProfileResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Profile       | UserProfile   | See UserProfile definition in Supporting Classes section

##### Error Messages
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’


#### <a name='get_progress'></a>Get Progress
```c#
public void GetProgress(bool sendData)
```
Call this method to retrieve game progress directly from GoPlay server. The progress is saved in a string field, either as xml or json. The progress is saved together with a meta field. 
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

Example:
```c#
GoPlaySdk.Instance.OnGetProgress += HandleOnGetProgress;
GoPlaySdk.Instance.GetProgress (true);
```
#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| sendData      | bool          | True or False. Optional, default True. Choose if the response should include the game save data, decrease traffic on server and client when only meta data and save_at timestamp are needed.

##### Output (GetProgressResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message 
| ErrorCode     | string        | Error Code
| Data          | string        |
| Meta          | string        | 

##### Error Messages

* MISSING_FIELDS - ‘Required field(s) is blank’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’

#### <a name='save_progress'></a>Save Progress

```c#
public void SaveProgress(string data, string meta=null)
```
Call this method to save game progress to GoPlay server. 


Example:

```c#
GoPlaySdk.Instance.OnSaveProgress += HandleOnSaveProgress;
GoPlaySdk.Instance.SaveProgess(data);
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| data          | string        | Data to be sent to server
| meta          | string        | Optional parameter 

##### Output (SaveProgressResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code

##### Error Messages

* MISSING_FIELDS - ‘Required field(s) is blank’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’

#### <a name='save_progress_file'></a>Save Progress File

```c#
public void SaveProgressFile(string fullPath, string meta=null)
```

Call this method to save game progress file of any extension to GoPlay server. 


Example:

```c#
GoPlaySdk.Instance.OnSaveProgress += HandleOnSaveProgress;
GoPlaySdk.Instance.SaveProgessFile(Application.dataPath + "/Sample/Sample1/data.json");
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| fullPath      | string        | Full path to the game progress storage file
| meta          | string        | Optional parameter 

##### Output (SaveProgressResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code

##### Error Messages

* MISSING_FIELDS - ‘Required field(s) is blank’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’

#### <a name='read_progress'></a>Read Progress

```c#
public void ReadProgress(string fullPath)
```

Because the game progress storage file is protected, call this method to download game progress file from GoPlay server. 

Example:

```c#
GoPlaySdk.Instance.OnReadProgress += HandleOnReadProgress;
GoPlaySdk.Instance.ReadProgress(Application.dataPath + "/Sample/Sample1/downloaded.json");
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| fullPath      | string        | Full path where the game progress storage file should be saved

##### Output (ReadProgressResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| FullPath      | string        | Full path where the game progress storage file was saved
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Er'Filename does not exist'ror Code

##### Error Messages

* MISSING_FIELDS - ‘Required field(s) is blank’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’
* NON_EXISTING_FILENAME - 'Filename does not exist'
* ERROR_READING_FILE

#### <a name='update_game_stats'></a>Update Game Stats

```c#
public void UpdateGameStats(string gameId, GameStats stats
```

Call this method in game client to save game stats directly to GoPlay server. The stat is saved as a string.
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

Example:

```c#
GoPlaySdk.Instance.OnUpdateGameStats += HandleOnUpdateGameStats;
GoPlaySdk.Instance.UpdateGameStats(GameId,gameStats);
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| gameId        | guid          | Required Parameter.
| stats         | array         | Required Parameter. Array of Game Stat. See Game Stat definition in Supporting Classes section 

##### Output (UpdateGameStatsResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code

##### Error Messages

* MISSING_FIELDS - ‘Required field(s) is blank’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_GAME_ID - ‘Invalid Game ID’
* INVALID_GAME_STAT - ‘Invalid stat format. A stat JSON must include 3 keys title, value and public with their values.’

#### <a name='get_unfulfilled_exchanges'></a>Get Unfulfilled Exchanges

```c#
public void GetUnFullFilledExchanges(string gameId)
```

Returns a list of unfulfilled exchanges made on GoPlay website
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

Example:

```c#
GoPlaySdk.Instance.OnGetUnFullFilledExchanges+= HandleOnGetUnFullFilledExchanges;
GoPlaySdk.Instance.GetUnFullFilledExchanges() ;
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| gameId        | guid          | Required Parameter.

##### Output (FullFillExchangeResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| Exchanges     | array         | Array of **Exchange**. See **Exchange** definition in Supporting Classes section

##### Error Messages

* INVALID_GAME_ID - ‘Invalid Game ID’
* INVALID_SESSION - ‘Invalid Session’

#### <a name='fulfill_exchange'></a>Fulfill Exchange

```c#
public void FullFillExchange(string gameId, string transactionId)
```

Call this method to fulfill an exchange made on GoPlay website.
An event will be triggered when server callbacks. This event must be hooked up before calling the API.

Example:

```c#
GoPlaySdk.Instance.OnFullFillExchange+= HandleOnFullFillExchange;
GoPlaySdk.Instance.FulfillExchange(GameId,transId);
```

#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| gameId        | guid          | Required Parameter
| transactionId | uuid          | Required parameter 


##### Output (FullFillExchangeResult)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Exchange      | Exchange      | The detail of the fulfilled exchange, for double checking. See **Exchange** definition in Supporting Classes section

##### Error Messages
* INVALID_GAME_ID - ‘Invalid Game ID’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_TRANSACTION_ID - ‘Invalid Transaction ID’
* TRANSACTION_ALREADY_PROCESSED - ‘Transaction has already been processed’

#### <a name='reject_exchange'></a>Reject Exchange
```c#
public void RejectExchange(string transactionId)
```
Reject an exchange made on GoPlay website. The rejected exchange’s status will be changed to failure and the user’s balance is redeemed.

Example:
```c#
GoPlaySdk.Instance.OnRejectExchange += HandleOnRejectExchange;
GoPlaySdk.Instance.RejectExchange(transactionId) ;
```
#####Input

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| transactionId | uuid          | Required Parameter


##### Output (JSON)

| Paramter      | Type          | Notes              
| ------------- |---------------| -------------------
| Succeeded     | bool          | 
| Message       | string        | Human-readable error message
| ErrorCode     | string        | Error Code
| Exchange      | Exchange      | The detail of the rejected exchange, for double checking. See **Exchange** definition in Supporting Classes section

##### Error Messages
* INVALID_GAME_ID - ‘Invalid Game ID’
* INVALID_SESSION - ‘Invalid Session’
* INVALID_TRANSACTION_ID - ‘Invalid Transaction ID’
* TRANSACTION_ALREADY_PROCESSED - ‘Transaction has already been processed’

### <a name='supporting_classes'></a>Supporting Classes
#### <a name='session'></a>Session
Contains all information regarding the player’s session, such as session ID, game ID and current user.

| Variable      | Type          | Notes              
| ------------- |---------------| -------------------
| gameId        | GTGameID      | Hold GameID class
| GameId        | string        | GameID guid type 
| HasLoggedIn   | boolean       | Whether the user has login before
| CurrentUser   | UserProfile   | The current user 
| SessionId     | string        | Id of current session
| GOPLAY_Session| string        | store cache key for session

#### <a name='userprofile'></a>UserProfile
All the information about user such as username, password, Gender, etc.

| Variable      | Type          | Notes              
| ------------- |---------------| -------------------
| Id            | int           | 
| UserName      | string        |  
| NickName      | string        | 
| Email         | string        |  
| Gender        | Gender        | 
| VipStatus     | Vip           | 
| CountryCode   | string        |  
| GoPlayToken   | decimal       | 
| FreeGoPlayToken| decimal      | 

#### <a name='exchange'></a>Exchange
This class holds information about user’s transactions.

| Variable                  | Type                      | Notes              
| -------------             |---------------            | -------------------
| TransactionId             | Guid                      | 
| ExchangeType              | ExchangeOptionTypes       |  
| ExchangeOptionIdentifier  | ExchangeOptionIdentifier  | 
| GoPlayTokenValue          | decimal                   |  
| Quantity                  | int                       | 
| IsFree                    | bool                      |  


#### <a name='game_stat'></a>GameStat
A JSON object representing a game stat, with the following keys:

| Variable      | Type          | Notes              
| ------------- |---------------| -------------------
| Title         | string        | 
| Value         | string        |  
| Public        | boolean       | 
