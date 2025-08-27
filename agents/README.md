# Claude Agents Directory

This directory contains a collection of specialized Claude agents designed to provide expert-level assistance across different domains of software development and product management. Each agent is optimized for specific tasks and brings deep domain expertise to help with complex technical and strategic challenges.

## Quick Reference

| Agent | Color | Primary Focus | Best For |
|-------|-------|---------------|----------|
| [backend-engineer](#backend-engineer) | 🟠 Orange | Backend systems & APIs | Database design, API development, infrastructure, security |
| [frontend-engineer](#frontend-engineer) | 🟣 Purple | Frontend development & testing | React components, Remix/Next.js, testing, performance |
| [system-architect](#system-architect) | 🩷 Pink | System design & architecture | Microservices, integrations, technical design docs |
| [product-manager](#product-manager) | 🔴 Red | Product strategy & requirements | PRDs, feature planning, user stories, roadmaps |
| [ux-design-expert](#ux-design-expert) | 🔵 Blue | UX/UI design & usability | Design systems, interface analysis, accessibility |

## When to Use Each Agent

### 🟠 Backend Engineer
**Use for:** API development, database schema design, authentication systems, microservices architecture, performance optimization, CI/CD pipelines, comprehensive testing strategies.

**Key Expertise:**
- Python/Node.js backend development (FastAPI, Flask, Nest.js, Express.js)
- Database design and optimization (SQL/NoSQL)
- Security implementation (JWT, OAuth2, RBAC)
- Infrastructure and DevOps (Docker, Kubernetes, monitoring)
- Testing at all levels (unit, integration, E2E)

### 🟣 Frontend Engineer  
**Use for:** React component development, Remix/Next.js applications, Tailwind CSS styling, frontend testing, performance optimization, build processes.

**Key Expertise:**
- Modern React patterns and TypeScript
- Remix loaders/actions and Next.js App Router
- Comprehensive testing (Jest, RTL, Playwright, Cypress)
- Responsive design with Tailwind CSS
- Frontend infrastructure and optimization

### 🩷 System Architect
**Use for:** System design, microservice architecture, API contracts, database schemas, integration planning, technical design documents, scalability planning.

**Key Expertise:**
- End-to-end system design and architecture
- Database schema design and relationships
- API specification and integration patterns
- Technical documentation and ERDs
- Scalability and maintainability planning

### 🔴 Product Manager
**Use for:** Feature planning, requirements analysis, PRD creation, user story writing, competitive research, product roadmaps, stakeholder communication.

**Key Expertise:**
- Breaking down complex features into actionable tasks
- Writing comprehensive Product Requirements Documents
- Requirements analysis and SMART criteria
- Product research and competitive analysis
- Stakeholder management and communication

### 🔵 UX Design Expert
**Use for:** Interface analysis, design systems, visual hierarchy improvements, accessibility audits, user experience optimization, design-development collaboration.

**Key Expertise:**
- Design system architecture and component libraries
- UI/UX analysis and usability improvements
- Accessibility standards (WCAG) compliance
- Visual design specifications for developers
- User experience optimization and best practices

## Usage Guidelines

### Agent Selection Strategy
1. **Single Domain Tasks**: Choose the agent that most closely matches your primary need
2. **Cross-Domain Projects**: Start with the system architect for overall design, then engage specific agents for implementation
3. **Complex Features**: Use product manager for initial breakdown, then technical agents for implementation

### Getting Optimal Results
- Provide clear context about your project, tech stack, and constraints
- Ask for specific deliverables (code examples, documentation, specifications)
- Request explanations of trade-offs and architectural decisions
- Specify your experience level for appropriately detailed responses

### Best Practices
- Reference the agent's color and expertise when requesting help
- Combine agents for comprehensive solutions (e.g., PM for requirements → Architect for design → Frontend/Backend for implementation)
- Use agents for code reviews and optimization suggestions
- Leverage their testing and documentation expertise

## Agent File Structure

Each agent follows a consistent format:

```yaml
---
name: agent-name
description: Detailed description with usage examples
color: assigned-color
---

Role definition and expertise areas...
```

### Frontmatter Fields
- **name**: Unique identifier for the agent
- **description**: Comprehensive description with usage examples and contexts
- **color**: Visual identifier for quick reference
- **content**: Detailed role definition, responsibilities, and approach

## Integration with Dotfiles

These agents are part of the broader dotfiles configuration system and designed to work seamlessly with:

- **Claude Code**: Direct integration for development workflows
- **Development Environment**: Aligned with existing tool configurations (Fish shell, Neovim, VSCode)
- **Project Standards**: Consistent with established coding practices and quality standards

## Creating New Agents

To add a new specialized agent:

1. Create a new `.md` file in the `agents/` directory
2. Follow the established frontmatter structure
3. Define clear expertise areas and responsibilities
4. Include specific usage examples and contexts
5. Assign an appropriate color for visual identification
6. Update this README with the new agent information

## Version Control

These agents are version-controlled as part of the dotfiles repository, allowing for:
- Evolution and refinement of agent capabilities
- Sharing and collaboration on agent definitions
- Consistent experience across development environments
- Tracking of changes and improvements over time

---

*This agents directory provides expert-level assistance across the full software development lifecycle, from initial product concepts to production deployment and maintenance.*