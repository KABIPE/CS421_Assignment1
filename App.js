import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import axios from 'axios';
import './App.css'; // You can create this file for styling

// Define API URL.  Use a relative URL, which will work with Docker Compose.
const API_BASE_URL = '/api'; //  No http://localhost:3000

const HomePage = ({ nodeName }) => {
    return (
        <div className="home-container">
            <h1 className="home-title">Welcome to the Front-End</h1>
            <p className="node-info">Serving Node: {nodeName}</p>
            <div className="button-container">
                <Link to="/students" className="home-button students-button">Students</Link>
                <Link to="/courses" className="home-button courses-button">Courses</Link>
            </div>
        </div>
    );
};

const StudentsPage = () => {
    const [students, setStudents] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchStudents = async () => {
            try {
                const response = await axios.get(`${API_BASE_URL}/students`);
                setStudents(response.data);
            } catch (err) {
                setError(err.message || 'Failed to fetch students');
            } finally {
                setLoading(false);
            }
        };
        fetchStudents();
    }, []);

    if (loading) {
        return <div className="loading">Loading Students...</div>;
    }

    if (error) {
        return <div className="error">Error: {error}</div>;
    }

    return (
        <div className="students-container">
            <h1 className="students-title">Students</h1>
            {students.length > 0 ? (
                <ul className="students-list">
                    {students.map((student) => (
                        <li key={student.id} className="student-item">
                            <span className="student-name">{student.name}</span>
                            <span className="student-program">({student.enrolled_program})</span>
                        </li>
                    ))}
                </ul>
            ) : (
                <p className="no-data">No students found.</p>
            )}
            <Link to="/" className="back-button">Back to Home</Link>

        </div>
    );
};

const CoursesPage = () => {
    const [subjects, setSubjects] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchSubjects = async () => {
            try {
                const response = await axios.get(`${API_BASE_URL}/subjects`);
                // Filter subjects for Software Engineering program.
                const softwareEngineeringSubjects = response.data.filter(subject =>
                    subject.program === 'Software Engineering'
                );
                setSubjects(softwareEngineeringSubjects);
            } catch (err) {
                setError(err.message || 'Failed to fetch courses');
            } finally {
                setLoading(false);
            }
        };
        fetchSubjects();
    }, []);

    if (loading) {
        return <div className="loading">Loading Courses...</div>;
    }

    if (error) {
        return <div className="error">Error: {error}</div>;
    }

    return (
        <div className="courses-container">
            <h1 className="courses-title">Software Engineering Courses</h1>
            {subjects.length > 0 ? (
                <ul className="courses-list">
                    {subjects.map((subject) => (
                        <li key={subject.id} className="course-item">
                            <span className="course-code">{subject.code}</span>
                            <span className="course-name">{subject.name}</span>
                            <span className="course-year">(Year {subject.year})</span>
                        </li>
                    ))}
                </ul>
            ) : (
                <p className="no-data">No courses found for Software Engineering.</p>
            )}
            <Link to="/" className="back-button">Back to Home</Link>
        </div>
    );
};

const App = () => {
    // Simulate different node names.  In a real HA setup, this would
    // come from an environment variable or configuration.
    const [nodeName, setNodeName] = useState('frontend1');

    useEffect(() => {
        const possibleNodes = ['frontend1', 'frontend2', 'frontend3'];
        let currentNodeIndex = 0;

        const intervalId = setInterval(() => {
            setNodeName(possibleNodes[currentNodeIndex]);
            currentNodeIndex = (currentNodeIndex + 1) % possibleNodes.length;
        }, 5000); // Change node name every 5 seconds

        return () => clearInterval(intervalId);
    }, []);

    return (
        <Router>
            <div className="app">
                <Routes>
                    <Route path="/" element={<HomePage nodeName={nodeName} />} />
                    <Route path="/students" element={<StudentsPage />} />
                    <Route path="/courses" element={<CoursesPage />} />
                </Routes>
            </div>
        </Router>
    );
};

export default App;
