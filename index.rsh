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
