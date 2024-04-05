import React from 'react';
import { useNavigate } from 'react-router-dom';
import './WalletConnectedPage.css';

const WalletConnectedPage = ({ account }) => {
  const navigate = useNavigate();
  
  const handleVoteListClick = () => {
    navigate('/voteList', { state: { account } });
  };

  return (
    <div className="wallet-connected-page">
      <div className="account-info">
        <p className="walletAddress">{account}</p>
      </div>
      <div>
        <button className="button-vote" onClick={handleVoteListClick}>Liste des votes</button>
      </div>
    </div>
  );
};

export default WalletConnectedPage;
