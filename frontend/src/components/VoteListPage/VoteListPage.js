import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom'; 
import './VoteListPage.css';

const VoteListPage = ({ account }) => {
  const [showForm, setShowForm] = useState(false);
  const [municipality, setMunicipality] = useState('');
  const [votes, setVotes] = useState([]);
  const navigate = useNavigate(); 

  const handleAddVoteClick = () => {
    setShowForm(true);
  };

  const handleFormSubmit = (e) => {
    e.preventDefault();
    setVotes([...votes, { municipality }]);
    setMunicipality('');
    setShowForm(false);
  };

  const navigateToVoteDetails = (index) => { 
    navigate(`/voteDetails/${index}`);
  };

  return (
    <div className="vote-list-page">
      <div className="account-info">
        <p className="walletAddress">{account}</p>
      </div>
      <div>
        <button className="button-add-vote" onClick={handleAddVoteClick}>Ajouter un vote</button>
        {showForm && (
          <form onSubmit={handleFormSubmit} className="vote-form">
            <input
              type="text"
              value={municipality}
              onChange={(e) => setMunicipality(e.target.value)}
              placeholder="Municipalité"
              required
            />
            <button type="submit">Valider</button>
          </form>
        )}
      </div>
      <div className="votes-list">
        {votes.map((vote, index) => (
          <div key={index} className="vote-item" onClick={() => navigateToVoteDetails(index)}>
            {vote.municipality}
          </div>
        ))}
      </div>
    </div>
  );
};

export default VoteListPage;
