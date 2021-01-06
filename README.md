# COP 5615 - Project 4.2
The goal of this project is to create a web application using phoenix framework to implement a Twitter-like engine and implement a simulation with atleast 100 users .

## Group Info
  - Shashi Prakash,  UFID:5891-2989
  - Shivam Agarwal,  UFID: 0319-3956

## How to Run
Unzip the content of the file and run the following command.
```mix run project4.ex arg1 arg2 ``` 

Sample Input:
```
mix run project4.ex arg1 arg2
arg1 is number of users 
arg2 is number of messages sent per user
```


## What is working
All the requirement which are mentioned in the problem statement are completed .

A single process is running for server and there is a separate process for each user.

Register account: A new process is created and registered in the server.

Delete account: Process terminated, Data deleted from server.

Delete account: Process terminated, Data deleted from server.

Subscribe: Adjacency list is maintained at server for keeping track of subscribers.

Tweet: When user sends out a message, server distributes it according to the Adjacency list and the user mentioned in the message.

Each tweet is stored against userName, taggedNames and hashTagged.


## Simulation
Adjacency List: An adjacency list has been created by every user subscribing to a random number of users between 0 to N^(1/2) (total number of users) picked from uniform distribution
The maximum number of hops were 5 and time to run for the largest set of nodes(10,000) was nearly equal to 
8 minutes.
Then each user sends out M messages at T time interval.
Retweet and Tagging: Retweet and tagging is simulated using a binomial distribution.
For every message received, user retweets it according to a binomial distribution.


## Largest Problem Solved
For 10,000 users we have 50 messages per user and time taken is 70.132362 seconds



![N|Solid](https://imgur.com/RL5H433.png)

![N|Solid](https://imgur.com/1qaIbo4.png)

## Test Cases 
Test cases include add and delete users, add subscribers and delete subscribers, query on user and query on tags
   ### Sample Input
         mix test
   ### Sample Output
  ![N|Solid](https://imgur.com/yMal4V4.png)


## Observations:
 - Increasing the number of users significantly increases the time taken.
 -  Time taken also depends on the graph (connectivity), for sparsely connected graph, time taken is much less than the graph with considerable connectivity.
- Increasing number of messages dosen't have that significant important

## UI Working
Phoenix framework id used for UI and web sockets .
Web sockets maintain a constant connection between the backend and the UI.
Simulation is a run for 100 users and  message per user.
UI displays the users registered and then the messages.

  ## how to run UI
    mix phx.server


