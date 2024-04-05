import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import './App.css';
import WalletConnectedPage from './components/WalletConnectedPage/WalletConnectedPage';
import VoteListPage from './components/VoteListPage/VoteListPage';
import VoteDetailsPage from './components/VoteDetailsPage/VoteDetailsPage'; // Importez la page VoteDetailsPage

function App() {
  const [account, setAccount] = useState('');

  const connectWalletHandler = async () => {
    const { ethereum } = window;
    if (!ethereum) {
      alert("MetaMask est nécessaire pour utiliser cette application.");
      return;
    }

    try {
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      setAccount(accounts[0]);
    } catch (err) {
      console.error(err);
    }
  };

  useEffect(() => {
    const { ethereum } = window;
    const checkIfWalletIsConnected = async () => {
      if (!ethereum) {
        console.log("MetaMask est nécessaire.");
        return;
      }
  
      const accounts = await ethereum.request({ method: 'eth_accounts' });
      if (accounts.length > 0) {
        const account = accounts[0];
        setAccount(account);
      } else {
        setAccount('');
      }
    };
  
    checkIfWalletIsConnected();
  
    const handleAccountsChanged = (accounts) => {
      if (accounts.length === 0) {
        
        setAccount('');
      } else {
        setAccount(accounts[0]);
      }
    };
  
    
    ethereum.on('accountsChanged', handleAccountsChanged);
  
    
    return () => ethereum.removeListener('accountsChanged', handleAccountsChanged);
  }, []);
  

  return (
    <Router>
      <Routes>
        <Route path="/" element={
          <div className="App">
            <header className="App-header">
              <p className="App-title">Votre application de votes sécurisés</p>
              {!account ? (
                <button className="button-auth" onClick={connectWalletHandler}>Connect Wallet</button>
              ) : (
                <Navigate replace to="/walletConnected" />
              )}
            </header>
          </div>
        } />
        <Route path="/walletConnected" element={<WalletConnectedPage account={account} />} />
        <Route path="/voteList" element={<VoteListPage account={account} />} /> 
        <Route path="/voteDetails/:voteId" element={<VoteDetailsPage account={account} />} /> 
      </Routes>
    </Router>
  );
}

export default App;
