This Tutorial would work you through building your first Decentralized Application using Reach... 

# Install and Initialize
Reach is designed to work on POSIX systems with make, Docker, and Docker Compose installed. The best way to install Docker on Mac and Windows is with Docker Desktop.2

You probably already have make installed. For example, OS X and many other POSIX systems come with make, but some versions of Linux do not include it by default and will require you to install it. If you're on Ubuntu, you can run sudo apt install make to get it.3

You'll know that you have everything installed if you can run the following three commands without errors4

 
 make --version
 
 docker --version
 
 docker-compose --version
If you're using Windows, consult the guide to using Reach on Windows.5

Once you've confirmed that they are installed, choose a directory for this project. We recommend6

 
 mkdir -p ~/reach/tut && cd ~/reach/tut
Next, download Reach by running7

 
 curl https://docs.reach.sh/reach -o reach ; chmod +x reach
You'll know that the download worked if you can run8

 
 ./reach version
The recommended next step, although optional, is to set up your environment with9

 
 ./reach config
This will make subsequent uses of the reach script more convenient by tuning its runtime behavior to your specific needs and only downloading the dependencies you'll actually use.10

reach config sets overridable defaults for all Reach projects on your development machine and not just the current one, so feel free to skip this step if you'd prefer not to make your choices global.11

Since Reach is Dockerized, when you first use it, you'll need to download the images it uses. Fetch them by running12

 
 ./reach update
You'll know that everything is in order if you can run13

 
 ./reach compile --help

# Introduction to web3 incase you're a newbie

What is blockchain : Simply put, a blockchain is a special kind of database. According to cigionline.org, the term blockchain refers to the whole network of distributed ledger technologies. According to Oxford Dictionaries, a ledger is “a book or other collection of financial accounts of a particular type.” It can be a computer file that records transactions. A ledger is actually the foundation of accounting and is as old as writing and money. Now imagine a whole suite of incorruptible digital ledgers of economic transactions that can be programmed to record and track not only financial transactions but also virtually everything of value. It is the work of a blockchain developer to build, maintain, and design blockchain applications and systems. Overall, it seeks to use the unique features of blockchain technology to solve problems and create opportunities.

2 - What is a decentralized application (DAPP) : A DAPP is basically any web application slapped on a blockchain, it is s an application that can operate autonomously, typically through the use of smart contracts, that runs on a decentralized computing, blockchain or other distributed ledger system. Like traditional applications, DApps provide some function or utility to its users. However, unlike traditional applications, DApps operate without human intervention and are not owned by any one entity, rather DApps distribute tokens that represent ownership.

3 - What is Reach : Reach is a domain-specific language for building decentralized applications (DApps). Reach provides a programming language and specialized compiler for developing decentralized applications. Developers can build applications twice as fast using Reach compared to current methods while automatically verifying their code’s correctness. Reach is so beautiful because it does so much for the developer in very little time with guaranteed security, reach checks all the theorems in the backend and validates if any of the players cheats or isn’t being fair making it the best blockchain platform from my own perspective based on speed, convenience and security.
#  Problem Analysis
The first step of designing any program is to perform problem analysis and determine what we have to do to successfully solve the problem. You should answer some questions concerning the design of the application to go through the same process I did while writing this project. You should also write your own answers in your Reach program (index.rsh) using a comment. /* Remember comments are written like this. */

- Who is involved in this application?
- What information do they know at the start of the program?
- What information are they going to discover and use in the program?
- What funds change ownership during the application and how?
 
Stop! Write down the problem analysis of this program as a comment.
Here's my answers to those questions:
- The Price is Right involves 2 roles: One player (Chuddy) who creates the game and a second player (Loveth) who joins the game.
- At the start of the program, Chuddy would know the wager and the timeout limit (deadline) they set for that particular session.
- Loveth would accept the wager and joins the Game
- Both player gives their guesses during course of the game
- Both player sees the Price at the end who is the winner. 
- The two players will pay the wager and the winner of the game would get paid both players' wagers as a reward.  

## Data Definition
For the next step, I am going to define the data type equivalents of the values I used in my answers from the previous section. Also, in this step I'll be deciding what functions our participants will have.

- What functions/values does Chuddy need to start the game?
- What functions/values does Loveth need to join the game?
- What functions/values do the two players need to play guesses?
- What functions/values do the two players need to inform the contract of winner?
Now this gives us fair idea about what functions we would need and lets start preparing our index.rsh file with these functions. 
``` javascript
1 'reach 0.1';
2 const [ isOutcome, C_WINS, DRAW, L_WINS ] = makeEnum(3);
3
4 const winner = (price, guessChuddy, guessLoveth) => {
5    if(guessChuddy==guessLoveth) {
6        return 1;
7    }
8    else if (guessLoveth == price) {
9         return 0;
10    }
11    else if(guessChuddy == price) {
12         return 2;
13    }
14    else {
15        return 1;
16    }
17  }
```
- Line 1 tells the compiler that this is a reach file and the version '0.1';
- Line 2 this defines enumerations for the outcome(IsOutcome) of the game, which is use to map  Staring to an Int which would be used  or computation,giving C_WINS:0, DRAW:1, and L_WINS:2 
- Line 4 to 17 defines a function that comuputes the winner of the game using their inputs and the random number as arguments
 giving conditions (using the if else if statement) that 
 - Line 5 to 7 if Chuddy Guess(Chuddy)  ==(is equals to)  Guess Loveth (Loveth)  than DRAW (the outcome mapped to the integer 1 Draw)
 - Line 8 to 10 if Guess Loveth (Loveth) =(is  equals to) price(the random number chosen by the blockchain) than W_WINS (the outcome mapped to the integer 2 wins)
- Line 11 to 13 if Chuddy Guess(Chuddy) ==(is equals to)  price (the random number chosen by the blockchain)  than F_WINS (the outcome mapped to the integer 0 wins)
- Line 14 to 17 a default condition if any of the above condition didn't working just return DRAW
```js
18 const Player = {
19  ...hasRandom,
20 getRandomNumber:Fun([], UInt),
21 getGuess: Fun([], UInt),
22 seeOutcome: Fun([UInt], Null),
23 informTimeout: Fun([], Null),
  };
```
- Line 18 to 23 is used to tell reach that this is the general player interface i.e the defining functions created in the frontend which both players have access to interact with.
- Line 19, `..hasRandom`  calls a blockchain function that compute for a random Number
- Line 20 `getRandomNumber: Fun([], UInt),` is a function that gets the random number for each player from the frontend and is then used as an argument in function `combineRandom ` to get the total random number for the game.
- Line 21 ` getGuess: Fun([], UInt),` is a function that gets an unsigned integer from the frontend, this integer is the guess of each player. 
- Line 22 `seeOutcome: Fun([UInt], Null),`  is a function that returns an unsigned integer to the frontend , and this integer is the output of the seeOutcome function which allows both players to see the outcome of the game on their screens.
- Line 23 `informTimeout: Fun([], Null),` is used for a timeout interact interface which both players can interact with

```js
26 export const main = Reach.App(() => {
27 const Chuddy = Participant('Chuddy', {
28   ...Player,
29  wager: UInt,
30  deadline: UInt, 
31 });
32 const Loveth   = Participant('Loveth', {
33  ...Player,
34 acceptWager: Fun([UInt], Null),
35 });
36 init();;
```
- Line 26 export the main,this compile the contract the main reach functions is written inside this compiler
- Line 27 to 36 is used to define the participants and assigning the appropriate funtions to the participants.
- Line 27 to 31 defines the Chuddy participant interface where Chuddy has access to the `Player` function and also a wager function that set the wager,accepting an UInt(unsigned integer(+integers)) from the frontens , the deadline for accepting that wager,
- Line 32 to 34 defines Loveth's interface with the `Player` function and the `acceptWager` where Loveth either accepts or declines the wager then attaches to the contract(those this by accepting an UInt from the frontend and returns nothing( Fun([UInt], Null)))
- Line 36 is used to initialize the application and finalizes all the available participants.

```js
37 const informTimeout = () => {
38  each([Chuddy, Loveth], () => {
39    interact.informTimeout();
40  });
41};
42 Chuddy.only(() => {
43 const wager = declassify(interact.wager);
44  const randomChuddy = declassify(interact.getRandomNumber());
45  const deadline = declassify(interact.deadline);
46});
47 Chuddy.publish(wager,randomChuddy,deadline).pay(wager);;
48 commit();
```
- Line 37 to 41 is the function that allows Chuddy and Loveth to interact with the timeout function.
- Line 38 to 40 shows an reach method (each) which help compute a similar program for the both Participant,Here it helps each Participant by taking in no value and returning  a reach getter function interact(which helps interact with our frontend) to call on our function InformTimeout() which would inform us of due timeout.  
- Line 42 to 46 is Chuddy interacting with his/her functions  i.e the wager function, deadline function for the timeout, and a random number from 1 to 10 which is created randomly by Chuddy's machine which is later on added to Loveth's random number to generate the total random number of the game, this helps to make the game as fair as possible making it impossible to cheat.
- Line 47 is used to broadcast/publish the following inputs by Chuddy to the blockchain so it can be seen that Chuddy made a wager, the deadline and the random number making all that known to the smart contractand and Chuddy pays the wager into the contract.
- Line 48 signifies the end of the current consensus step.

```js
50  Loveth.only(() => {
51    interact.acceptWager(wager);
52    const randomLoveth = declassify(interact.getRandomNumber());
53  });
54  Loveth.publish(randomLoveth).pay(wager).timeout(relativeTime(deadline), () => closeTo(Chuddy, informTimeout));

```
- In line 49 to 98 Loveth accepts the wager and interacts with the `getRandom` function to generate his/her own random number which is a number ranging 1 - 10.
- On line 54 Loveth publishes his random number.
- On line 54 Loveth pays a the wager
- Line 54 Loveth is interacting with the timeout function.

```js
56 const price = (randomLoveth+randomChuddy)/2;
57 var outcome = DRAW;
58 invariant( balance() == 2 * wager && isOutcome(outcome) );
59
60 while ( outcome == DRAW ) {
61 commit();
62 Chuddy.only(() => {
63 const _guessChuddy = interact.getGuess();
64  const [_commitChuddy, _saltChuddy] = makeCommitment(interact, _guessChuddy);
65  const commitChuddy = declassify(_commitChuddy);
66 });
67 Chuddy.publish(commitChuddy);
68 commit();
69
70 unknowable(Loveth, Chuddy(_guessChuddy, _saltChuddy));
```
- Line 56 shows a variable price that is equal to the sum of the random guess of Chuddy and Loveth divided by two. 
- On line 57 is the var which is a variable that the values can change unlike a const which is a constant and must remain that.This would help hold the outcome which can change deprnding on the result of the game.
- Line 58 is the invariant which is a statement that must be true throughout the code, i.e before and after the while loop, if this is false at any time during compilation it would return a theorem violation error.
- Line 60 is the begining of the while loop and using the following conditions the while loop continues until either of the conditions are met, the idea is that the players keep on playing until either of them get the correct answer.
- On Line 62 to 68 Chuddy interacts with the get hand function and the input is stores in `_handChuddy` which is then passed through a makeCommitment function which returns a commit and salt for the input where salt is the result of calling interact.random(), and  commitment is the digest of salt and _handChuddy. This helps to make the input of Chuddy hidden before revealing at the same time when Loveth interacts with the same function making it impossible to cheat.
- Line 70 is used to verify that Chuddy guess is unknown to Loveth.
```js
71 Loveth.only(() => {
72 const guessLoveth = declassify(interact.getGuess());
73 });
74 Loveth.publish(guessLoveth).timeout(relativeTime(deadline), () => closeTo(Chuddy, informTimeout));
75 commit();
76 Chuddy.only(() => {
77 const saltChuddy = declassify(_saltChuddy);
78  const guessChuddy = declassify(_guessChuddy);
79 });
80 Chuddy.publish(saltChuddy, guessChuddy).timeout(relativeTime(deadline), () => closeTo(Loveth, informTimeout));;
81 checkCommitment(commitChuddy, saltChuddy, guessChuddy);
```
- On line 71 to 73 Loveth interacts with the getGuess function i.e inputing his/her guess.
- And the next line Loveth publishes his input, but line 74 is used so Loveths input is been displayed at the same time Chuddy input was displayed to avoid any form of unfairness.
- Line 76 to 79 is used to declassify Chuddy salt and digest, publishes it and displays it at the same time Loveth displays his/hers.
- Line 81 is used to verify if that commitment is the digest of saltChuddy and handChuddy

```js
82 outcome = winner(price, guessChuddy, guessLoveth);
83          continue;
84    }
85      const            [forChuddy, forLoveth] =
86      outcome == 0 ? [       0,      2] :
87      outcome == 2 ? [       2,      0] :
88      /* tie      */ [       1,      1];
89      transfer(forChuddy * wager).to(Chuddy);
90      transfer(forLoveth   * wager).to(Loveth);
91      commit();
92      each([Chuddy, Loveth], () => {
93        interact.seeOutcome(outcome,price);
94      });

});
```
- Line 82 updates the variable outcome with new values
- Line 83 continues the loop
- Line 84 to 88 show how the result or outcome would be for example line 92 says if outcome == 0 then Chuddy win else Loveth wins.
- Line 86 transfer wagers to Chuddy if Chuddy wins
- Line 87 transfer wagers to Loveth if Loveth wins
- Line 91 commits to te blockchain
- Line 92 to 94 shows an reach method (each) which help compute a similar program for the both Participant,Here it helps each Participant by taking in no value and returning  a reach getter function interact(which helps interact with our frontend) to call on our function seeOutcome() which would show us the Outcome. 
```js
```
# Finalization 
The `index.rsh` file should look like this
```js
'reach 0.1';
const [ isOutcome, C_WINS, DRAW, L_WINS ] = makeEnum(3);

const winner = (price, guessChuddy, guessLoveth) => {
    if(guessChuddy==guessLoveth) {
        return 1;
    }
    else if (guessLoveth == price) {
         return 0;
    }
    else if(guessChuddy == price) {
         return 2;
    }
    else {
        return 1;
    }
  };
const Player = {
    ...hasRandom,
    getRandomNumber:Fun([], UInt),
    getGuess: Fun([], UInt),
    seeOutcome: Fun([UInt,UInt], Null),
    informTimeout: Fun([], Null),
  };
  
export const main = Reach.App(() => {
  const Chuddy = Participant('Chuddy', {
    ...Player,
    wager: UInt,
    deadline: UInt, 
  });
  const Loveth   = Participant('Loveth', {
    ...Player,
    acceptWager: Fun([UInt], Null),
  });
  init();
  const informTimeout = () => {
    each([Chuddy, Loveth], () => {
      interact.informTimeout();
    });
  };
  Chuddy.only(() => {
    const wager = declassify(interact.wager);
    const randomChuddy = declassify(interact.getRandomNumber());
    const deadline = declassify(interact.deadline);
  });
  Chuddy.publish(wager,randomChuddy,deadline).pay(wager);;
  commit();

  Loveth.only(() => {
    interact.acceptWager(wager);
    const randomLoveth = declassify(interact.getRandomNumber());
  });
  Loveth.publish(randomLoveth).pay(wager).timeout(relativeTime(deadline), () => closeTo(Chuddy, informTimeout));

  const price = (randomChuddy+randomLoveth)/2;
  var outcome = DRAW;
  invariant( balance() == 2 * wager && isOutcome(outcome) );

  while ( outcome == DRAW ) {
    commit();
  Chuddy.only(() => {
    const _guessChuddy = interact.getGuess();
    const [_commitChuddy, _saltChuddy] = makeCommitment(interact, _guessChuddy);
    const commitChuddy = declassify(_commitChuddy);
  });
  Chuddy.publish(commitChuddy);
  commit();

  unknowable(Loveth, Chuddy(_guessChuddy,_saltChuddy));
  Loveth.only(() => {
    const guessLoveth = declassify(interact.getGuess());
  });
  Loveth.publish(guessLoveth).timeout(relativeTime(deadline), () => closeTo(Chuddy, informTimeout));
  commit();
  Chuddy.only(() => {
    const saltChuddy = declassify(_saltChuddy);
    const guessChuddy = declassify(_guessChuddy);
  });
  Chuddy.publish(saltChuddy, guessChuddy).timeout(relativeTime(deadline), () => closeTo(Loveth, informTimeout));;
  checkCommitment(commitChuddy, saltChuddy, guessChuddy);
  outcome = winner(price, guessChuddy, guessLoveth);
  continue;
}
  const            [forChuddy, forLoveth] =
  outcome == 2 ? [       2,      0] :
  outcome == 0 ? [       0,      2] :
  /* tie      */ [       1,      1];
  transfer(forChuddy * wager).to(Chuddy);
  transfer(forLoveth   * wager).to(Loveth);
  commit();
  each([Chuddy, Loveth], () => {
    interact.seeOutcome(outcome,price);
  });
});
```




That's all about contract. Now lets write our interactions. 



# Interaction :
Now that we have a complete contract, we can write the frontend. Since we'll be interacting with an API to play the actual The Price is Right game, using a web frontend library is a better choice. In our case it will be React. The code below was wrote using Typescript. For state management, the redux library was used.

Stop! Insert  `interact` calls to the [frontend](https://docs.reach.sh/model/#ref-model) into the program.
```
```
```js

import React from 'react';
import AppViews from './views/AppViews';
import DeployerViews from './views/DeployerViews';
import AttacherViews from './views/AttacherViews';
import { renderDOM, renderView } from './views/render';
import './index.css';
import * as backend from './build/index.main.mjs';
import { loadStdlib,ALGO_MyAlgoConnect as MyAlgoConnect } from '@reach-sh/stdlib';
const reach = loadStdlib(process.env);
const intToOutcome = ['Loveth wins!', 'Draw!', 'Chuddy wins!'];
const { standardUnit } = reach;
const defaults = { defaultFundAmt: '10', defaultWager: '3', standardUnit };

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { view: 'ConnectAccount', ...defaults };
  }
  async componentDidMount() {
    console.log("component mounted");
    reach.setWalletFallback(reach.walletFallback({providerEnv:'TestNet',MyAlgoConnect}))
    const acc = await reach.getDefaultAccount();
    const balAtomic = await reach.balanceOf(acc);
    const bal = reach.formatCurrency(balAtomic, 4);
    this.setState({ acc, bal });
    if (await reach.canFundFromFaucet()) {
      this.setState({ view: 'FundAccount' });
    } else {
      this.setState({ view: 'DeployerOrAttacher' });
    }
  }
  async fundAccount(fundAmount) {
    await reach.fundFromFaucet(this.state.acc, reach.parseCurrency(fundAmount));
    this.setState({ view: 'DeployerOrAttacher' });
  }
  async skipFundAccount() { this.setState({ view: 'DeployerOrAttacher' }); }
  selectAttacher() { this.setState({ view: 'Wrapper', ContentView: Attacher }); }
  selectDeployer() { this.setState({ view: 'Wrapper', ContentView: Deployer }); }
  render() { return renderView(this, AppViews); }
}

class Player extends React.Component {
  random() { return reach.hasRandom.random(); }
  async getRandomNumber() { // Fun([], UInt)
    const randomNumber = Math.floor(Math.random() * 10);
    console.log("randomNumber"+randomNumber);
    return randomNumber;
  }
  async getGuess() { // Fun([], UInt)
    const guess = await new Promise(resolveGuessP => {
      this.setState({ view: 'GetGuess', playable: true, resolveGuessP });
    });
    this.setState({ view: 'WaitingForResults', guess });
    return guess;
  }
 
  seeOutcome(i,price) { 
    this.setState({ view: 'Done', outcome: intToOutcome[i], price: ""+price }); 
  }
  informTimeout() { this.setState({ view: 'Timeout' }); }
  playGuess(guess) { this.state.resolveGuessP(guess); }
}

class Deployer extends Player {
  constructor(props) {
    super(props);
    this.state = { view: 'SetWager' };
  }
  setWager(wager) { this.setState({ view: 'Deploy', wager }); }
  async deploy() {
    const ctc = this.props.acc.contract(backend);
    this.setState({ view: 'Deploying', ctc });
    this.wager = reach.parseCurrency(this.state.wager); // UInt
    this.deadline = { ETH: 10, ALGO: 100, CFX: 1000 }[reach.connector]; // UInt
    backend.Chuddy(ctc, this);
    const ctcInfoStr = JSON.stringify(await ctc.getInfo(), null, 2);
    this.setState({ view: 'WaitingForAttacher', ctcInfoStr });
  }
  render() { return renderView(this, DeployerViews); }
}
class Attacher extends Player {
  constructor(props) {
    super(props);
    this.state = { view: 'Attach' };
  }
  attach(ctcInfoStr) {
    const ctc = this.props.acc.contract(backend, JSON.parse(ctcInfoStr));
    this.setState({ view: 'Attaching' });
    backend.Loveth(ctc, this);
  }
  async acceptWager(wagerAtomic) { // Fun([UInt], Null)
    const wager = reach.formatCurrency(wagerAtomic, 4);
    return await new Promise(resolveAcceptedP => {
      this.setState({ view: 'AcceptTerms', wager, resolveAcceptedP });
    });
  }
  termsAccepted() {
    this.state.resolveAcceptedP();
    this.setState({ view: 'WaitingForTurn' });
  }
  render() { return renderView(this, AttacherViews); }
}

renderDOM(<App />);
```
```

# Discussion 
Congrats for making it to the end of the tutorial. You succeeded in implementing the The Price is Right game to run on the blockchain all by yourself!

The same concept can be implemented for a wide variety of board games like chess, checkers  etc.

Link to our code(https://github.com/chuddyJay/pris)


