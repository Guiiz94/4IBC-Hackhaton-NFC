import React, { useState } from 'react';
import { useParams } from 'react-router-dom'; 
import './VoteDetailsPage.css'; 

const VoteDetailsPage = ({ account }) => {
  const [showForm, setShowForm] = useState(false);
  const { voteId } = useParams(); 
  const [candidatename, setCandidateName] = useState([]);
  const [candidates, setCandidates] = useState([]);

  const handleAddCandidate = () => {
    setShowForm(true);
  };

  const handleFormSubmit = (e) => {
    e.preventDefault();
    setCandidates([...candidates, candidatename]);
    setCandidateName('');
    setShowForm(false);
  }

  return (
    <div className="vote-details-page">
      <div className="account-info">
        <p className="walletAddress">{account}</p> 
      </div>
      <h2>Détails du vote {voteId}</h2>
      <div>
      <button className="button-add-candidate" onClick={handleAddCandidate}>Ajouter un candidat</button>
      {showForm && (
          <form onSubmit={handleFormSubmit} className="candidat-form">
            <input
              type="text"
              value={candidatename}
              onChange={(e) => setCandidateName(e.target.value)}
              placeholder="Candidat"
              required
            />
            <button type="submit">Valider</button>
          </form>
        )}
      </div>
        <div className="candidates-list">
            {candidates.map((candidate, index) => (
            <div key={index} className="candidate-item">
                {candidate}
            </div>
            ))}
        </div>
    </div>
  );
};

export default VoteDetailsPage;
