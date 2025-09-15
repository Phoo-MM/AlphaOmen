# AlphaOmen
“Alpha Omen – A Java-based note-taking and productivity web app with voice notes, Pomodoro timer, calculator, mood tracker, and AI chatbot. Built with JSP, Servlets, BootStrap and MySQL.

# 🌟Features
- Note-Taking: Create, edit, pin, import, and export notes  
- Voice Recording: Record and attach audio to notes  
- Timer (Pomodoro/ Custom): Focus sessions with customizable intervals  
- Calculator: Quick computations without leaving the app  
- Mood Tracker: Log and track emotional well-being  
- AI Chatbo*: Rule-based FAQ assistant
- Text Auto-Correct (Jupyter): Machine-learning powered text correction feature
- Freemium Model: Free tier with ads, Premium tier with advanced features

# 🛠️Technologies
- Frontend: HTML5, CSS3, JavaScript, Bootstrap  
- Backend: Java (JSP & Servlets)  
- Database: MySQL (XAMPP)  
- Server: Apache Tomcat 10  
- Version Control: Git & GitHub

# 📂Project Structure
- /src – Java source files
- /webapp – JSP, CSS, JS
- /database – SQL scripts
- /autocorrect – Python + Jupyter Notebook files for text auto-correct
- README.md – Project overview

# 🚀Setup Instructions
1️⃣ Prerequisites
- Eclipse IDE with Maven support
- Apache Tomcat 10.0 configured in Eclipse
- MySQL / XAMPP installed
- Python 3.10+ with Jupyter Notebook installed

2️⃣ Clone Repository
```
git clone https://github.com/<your-repo-link>.git
```

3️⃣ Project Placement
- Place both the AlphaOmen project folder and the autocorrect folder inside the same Eclipse workspace:
```
eclipse-workspace/
 ├─ AlphaOmen/
 └─ autocorrect/
```

4️⃣ Run Jupyter Notebook (Autocorrect)
- Open CMD/Terminal
- Navigate to the autocorrect folder:
```
cd path\to\eclipse-workspace\autocorrect
```
- Start Jupyter Notebook
```
jupyter notebook
```
- Your browser will open the Jupyter interface.
- Open the ```.ipynb``` file and Run All Cells/ Run Kernel.
- Leave it running in the background.

5️⃣ Run Eclipse Project (AlphaOmen)
- Import the AlphaOmen Maven project into Eclipse.
- Configure Tomcat Server (v10.0).
- Import the SQL file into MySQL (via phpMyAdmin or MySQL Workbench).
- Run the project on localhost:8081.
```
⚠️ Important: Always start the Jupyter Notebook before running the Eclipse project.
```

# 📈Future Enhancements
- Mobile app version
- Speech-to-text for voice notes
- Real-time collaboration
- AI-powered note summarization

# 👩‍💻Team Members
@Sociopath345
@Ketty-97

```
Note: This repository contains the code and resources for the Alpha Omen project developed as part of our coursework.
```
