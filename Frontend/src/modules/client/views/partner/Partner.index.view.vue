<template>
    <div class="partners-page">
        <!-- Hero Section -->
        <section class="hero-section">
            <div class="container">
                <div class="hero-content">
                    <h1 class="hero-title">Join Forces with MelodyHub</h1>
                    <div class="hero-actions">
                        <button class="btn-primary" @click="scrollToForm">
                            Become a Partner Now
                        </button>
                        <a href="#benefits" class="btn-secondary">
                            Learn More
                        </a>
                    </div>
                </div>
                <div class="hero-image">
                    <img src="@/assets/images/partner/partners-hero.jpg" alt="Partners Collaboration">
                </div>
            </div>
        </section>

        <!-- Stats Section -->
        <section class="stats-section">
            <div class="container">
                <div class="stats-grid">
                    <div class="stat-item">
                        <h3 class="stat-number">500K+</h3>
                        <p class="stat-label">Active Users</p>
                    </div>
                    <div class="stat-item">
                        <h3 class="stat-number">10K+</h3>
                        <p class="stat-label">Artists & Creators</p>
                    </div>
                    <div class="stat-item">
                        <h3 class="stat-number">100+</h3>
                        <p class="stat-label">Current Partners</p>
                    </div>
                    <div class="stat-item">
                        <h3 class="stat-number">1M+</h3>
                        <p class="stat-label">Monthly Streams</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Why Partner With Us -->
        <section id="benefits" class="benefits-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Why Partner With MelodyHub?</h2>
                    <p class="section-subtitle">Create Breakthrough Value in the Music Industry Together</p>
                </div>
                
                <div class="benefits-grid">
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3>Passionate Community</h3>
                        <p>Access hundreds of thousands of music lovers, artists, and content creators</p>
                    </div>
                    
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Grow Together</h3>
                        <p>Special support programs, revenue sharing, and long-term development opportunities</p>
                    </div>
                    
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="fas fa-tools"></i>
                        </div>
                        <h3>Powerful Tools</h3>
                        <p>Professional toolkit: Analytics, Promotion, Monetization features</p>
                    </div>
                    
                    <div class="benefit-card">
                        <div class="benefit-icon">
                            <i class="fas fa-handshake"></i>
                        </div>
                        <h3>Dedicated Support</h3>
                        <p>Expert team providing 24/7 support and guidance</p>
                    </div>
                </div>
            </div>
        </section>

       

        <!-- Success Stories -->
        <section class="stories-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Success Stories</h2>
                    <p class="section-subtitle">Hear from our valued partners</p>
                </div>
                
                <div class="stories-slider">
                    <div class="story-card">
                        <div class="story-content">
                            <p class="story-text">
                                "Partnering with MelodyHub transformed our artist management. The platform's tools and audience reach helped our artists grow 300% in 6 months."
                            </p>
                            <div class="story-author">
                                <img src="@/assets/images/partner/partner1.jpg" alt="Sarah Johnson" class="author-avatar">
                                <div class="author-info">
                                    <h4>Sarah Johnson</h4>
                                    <p>CEO, Harmony Records</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="story-card">
                        <div class="story-content">
                            <p class="story-text">
                                "The brand integration opportunities through MelodyHub connected us with authentic music creators, delivering 5x ROI on our marketing campaigns."
                            </p>
                            <div class="story-author">
                                <img src="@/assets/images/partner/partner2.jpg" alt="David Chen" class="author-avatar">
                                <div class="author-info">
                                    <h4>David Chen</h4>
                                    <p>Marketing Director, SoundWave Audio</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section" id="contact-form">
            <div class="container">
                <div class="cta-content">
                    <h2 class="cta-title">Ready to Amplify Your Music Impact?</h2>
                    <p class="cta-subtitle">Join our network of successful partners and grow with Vietnam's fastest-growing music platform.</p>
                    
                    <div class="contact-form">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="company">Company Name *</label>
                                <input type="text" id="company" v-model="form.company" placeholder="Your company name">
                            </div>
                            <div class="form-group">
                                <label for="name">Your Name *</label>
                                <input type="text" id="name" v-model="form.name" placeholder="Full name">
                            </div>
                            <div class="form-group">
                                <label for="email">Email Address *</label>
                                <input type="email" id="email" v-model="form.email" placeholder="you@company.com">
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" id="phone" v-model="form.phone" placeholder="+84">
                            </div>
                            <div class="form-group full-width">
                                <label for="interest">Partnership Interest *</label>
                                <select id="interest" v-model="form.interest">
                                    <option value="">Select partnership type</option>
                                    <option value="artist">Artist/Label Partnership</option>
                                    <option value="brand">Brand/Sponsor Partnership</option>
                                    <option value="tech">Technology Partnership</option>
                                    <option value="other">Other Collaboration</option>
                                </select>
                            </div>
                            <div class="form-group full-width">
                                <label for="message">Tell us about your goals</label>
                                <textarea id="message" v-model="form.message" placeholder="How can we collaborate? What are your objectives?"></textarea>
                            </div>
                        </div>
                        
                        <div class="form-footer">
                            <button class="submit-btn" @click="submitForm" :disabled="loading">
                                {{ loading ? 'Sending...' : 'Submit Partnership Request' }}
                            </button>
                            <p class="form-note">We'll contact you within 24 hours to discuss partnership opportunities.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="faq-section">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Frequently Asked Questions</h2>
                    <p class="section-subtitle">Find answers to common partnership questions</p>
                </div>
                
                <div class="faq-list">
                    <div class="faq-item" v-for="(faq, index) in faqs" :key="index">
                        <div class="faq-question" @click="toggleFaq(index)">
                            <h3>{{ faq.question }}</h3>
                            <i class="fas" :class="faq.open ? 'fa-chevron-up' : 'fa-chevron-down'"></i>
                        </div>
                        <div class="faq-answer" v-if="faq.open">
                            <p>{{ faq.answer }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

const form = reactive({
    company: '',
    name: '',
    email: '',
    phone: '',
    interest: '',
    message: ''
})

const loading = ref(false)
const activeModal = ref<string | null>(null)
const faqs = ref([
    {
        question: 'What are the benefits of becoming a MelodyHub partner?',
        answer: 'Partners gain access to our growing user base, advanced analytics tools, revenue sharing opportunities, dedicated support team, and exclusive promotional features.',
        open: false
    },
    {
        question: 'How long does the onboarding process take?',
        answer: 'Typically 3-5 business days after approval. We expedite the process for established artists and brands.',
        open: false
    },
    {
        question: 'Is there a minimum commitment period?',
        answer: 'We offer flexible partnership terms starting from 3 months to multi-year agreements, depending on the partnership model.',
        open: false
    },
    {
        question: 'What revenue sharing models are available?',
        answer: 'We offer multiple models including revenue share, flat fee, hybrid models, and custom arrangements based on partnership type and volume.',
        open: false
    },
    {
        question: 'Do you provide marketing support?',
        answer: 'Yes, we offer comprehensive marketing support including campaign planning, content creation, social media promotion, and performance analytics.',
        open: false
    }
])

const scrollToForm = () => {
    const element = document.getElementById('contact-form')
    element?.scrollIntoView({ behavior: 'smooth' })
}

const toggleFaq = (index: number) => {
    faqs.value[index].open = !faqs.value[index].open
}

const openModal = (type: string) => {
    activeModal.value = type
    // You can implement modal logic here
    console.log('Opening modal for:', type)
}

const submitForm = async () => {
    if (!form.company || !form.name || !form.email || !form.interest) {
        alert('Please fill in all required fields')
        return
    }

    loading.value = true
    try {
        // Implement API call here
        console.log('Form submitted:', form)
        
        // Simulate API call
        await new Promise(resolve => setTimeout(resolve, 1500))
        
        alert('Thank you for your interest! Our partnership team will contact you within 24 hours.')
        
        // Reset form
        Object.keys(form).forEach(key => {
            form[key as keyof typeof form] = ''
        })
    } catch (error) {
        console.error('Error submitting form:', error)
        alert('Something went wrong. Please try again.')
    } finally {
        loading.value = false
    }
}
</script>

<style scoped>
.partners-page {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    color: #1a1a1a;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
}

/* Hero Section */
.hero-section {
    background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 100%);
    color: white;
    padding: 120px 0 100px;
    position: relative;
    overflow: hidden;
}

.hero-section::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        radial-gradient(circle at 20% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
        radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.08) 0%, transparent 50%);
    pointer-events: none;
}


.hero-section .container {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 60px;
    position: relative;
    z-index: 1;
}

.hero-content {
    flex: 1;
    max-width: 600px;
    animation: fadeInUp 0.8s ease-out;
}
.hero-title {
    font-size: 3.75rem;
    font-weight: 800;
    line-height: 1.1;
    margin-bottom: 1.5rem;
    background: linear-gradient(45deg, #ffffff, #e0f2ff);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    text-shadow: 0 4px 20px rgba(29, 78, 216, 0.3);
    letter-spacing: -0.5px;
}

.hero-subtitle {
    font-size: 1.4rem;
    opacity: 0.95;
    margin-bottom: 2.5rem;
    line-height: 1.6;
    font-weight: 400;
    max-width: 90%;
    color: rgba(255, 255, 255, 0.95);
}

.hero-subtitle::before {
    content: '• ';
    color: #60a5fa;
    font-weight: bold;
    margin-right: 8px;
}

.hero-actions {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
    margin-top: 40px;
}

.btn-primary, .btn-secondary {
    padding: 18px 40px;
    border-radius: 12px;
    font-weight: 600;
    font-size: 1.1rem;
    cursor: pointer;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 200px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
.btn-primary {
    background: linear-gradient(135deg, #ffffff 0%, #f0f9ff 100%);
    color: #1d4ed8;
    border: none;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.25),
        0 0 0 1px rgba(255, 255, 255, 0.1);
}

.btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: 0.6s;
}

.btn-primary:hover {
    transform: translateY(-4px);
    box-shadow: 
        0 20px 40px rgba(0, 0, 0, 0.3),
        0 0 0 1px rgba(255, 255, 255, 0.2);
}

.btn-primary:hover::before {
    left: 100%;
}
.btn-primary:active {
    transform: translateY(-1px);
}

.btn-secondary {
    background: transparent;
    color: white;
    border: 2px solid rgba(255, 255, 255, 0.4);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
}
.btn-secondary:hover {
    background: rgba(255, 255, 255, 0.15);
    border-color: white;
    transform: translateY(-4px);
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
}

.hero-image {
    /* width: 800px;
    height: 800px; */
    flex: 1;
    border-radius: 5px;
    text-align: center;
    animation: floatIn 1s ease-out 0.2s both;
}

.hero-image img {
    max-width: 100%;
    height: auto;
    filter: 
        drop-shadow(0 25px 50px rgba(0, 0, 0, 0.4))
        brightness(1.05);
    transform-style: preserve-3d;
    transform: perspective(1000px) rotateY(-5deg);
    transition: transform 0.5s ease;
}

.hero-image:hover img {
    transform: perspective(1000px) rotateY(0deg);
}

/* Stats Section */
.stats-section {
    padding: 80px 0;
    background: #f8fafc;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 40px;
    text-align: center;
}

.stat-item {
    padding: 30px;
}

.stat-number {
    font-size: 3rem;
    font-weight: 800;
    color: #1d4ed8;
    margin-bottom: 10px;
}

.stat-label {
    font-size: 1.1rem;
    color: #64748b;
    font-weight: 500;
}

/* Benefits Section */
.benefits-section {
    padding: 100px 0;
    background: white;
}

.section-header {
    text-align: center;
    margin-bottom: 60px;
}

.section-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 1rem;
}

.section-subtitle {
    font-size: 1.25rem;
    color: #64748b;
    max-width: 600px;
    margin: 0 auto;
}

.benefits-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 30px;
}

.benefit-card {
    padding: 40px 30px;
    border-radius: 20px;
    background: white;
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
    transition: transform 0.3s ease;
    text-align: center;
}

.benefit-card:hover {
    transform: translateY(-10px);
}

.benefit-icon {
    width: 80px;
    height: 80px;
    background: linear-gradient(135deg, #1d4ed8, #764ba2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 30px;
}

.benefit-icon i {
    font-size: 2rem;
    color: white;
}

.benefit-card h3 {
    font-size: 1.5rem;
    font-weight: 600;
    margin-bottom: 15px;
    color: #1e293b;
}

.benefit-card p {
    color: #64748b;
    line-height: 1.6;
}

/* Models Section */
.models-section {
    padding: 100px 0;
    background: #f8fafc;
}

.models-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
}

.model-card {
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
    transition: all 0.3s ease;
}

.model-card.featured {
    border: 2px solid #1d4ed8;
    transform: scale(1.05);
}

.model-header {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #e2e8f0;
}

.model-header h3 {
    font-size: 1.5rem;
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 10px;
}

.model-badge {
    display: inline-block;
    padding: 6px 12px;
    background: #1d4ed8;
    color: white;
    border-radius: 20px;
    font-size: 0.875rem;
    font-weight: 600;
}

.model-features {
    list-style: none;
    margin-bottom: 40px;
}

.model-features li {
    display: flex;
    align-items: flex-start;
    margin-bottom: 15px;
    color: #475569;
}

.model-features i {
    color: #10b981;
    margin-right: 10px;
    margin-top: 3px;
}

.model-cta {
    width: 100%;
    padding: 15px;
    border: 2px solid #e2e8f0;
    background: white;
    color: #475569;
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}

.model-cta:hover {
    background: #f8fafc;
}

.model-cta.primary {
    background: #1d4ed8;
    color: white;
    border-color: #1d4ed8;
}

.model-cta.primary:hover {
    background: #5a67d8;
}

/* Stories Section */
.stories-section {
    padding: 100px 0;
    background: white;
}

.stories-slider {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
}

.story-card {
    background: #f8fafc;
    border-radius: 20px;
    padding: 40px;
}

.story-text {
    font-size: 1.125rem;
    line-height: 1.7;
    color: #475569;
    margin-bottom: 30px;
    font-style: italic;
}

.story-author {
    display: flex;
    align-items: center;
    gap: 15px;
}

.author-avatar {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    object-fit: cover;
}

.author-info h4 {
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 5px;
}

.author-info p {
    color: #64748b;
    font-size: 0.875rem;
}

/* CTA Section */
.cta-section {
    padding: 120px 0 150px;
    background: linear-gradient(135deg, #1d4ed8 0%, #764ba2 100%);
    color: white;
    position: relative;
    overflow: hidden;
}

.cta-section::before {
    content: '';
    position: absolute;
    top: -50px;
    left: 0;
    right: 0;
    height: 100px;
    background: white;
    border-radius: 0 0 50% 50%;
    transform: scaleX(1.1);
}

.cta-section::after {
    content: '';
    position: absolute;
    bottom: -50px;
    left: 0;
    right: 0;
    height: 100px;
    background: white;
    border-radius: 50% 50% 0 0;
    transform: scaleX(1.1);
}

.cta-section.top-curve {
    padding: 150px 0 100px;
}

.cta-section.top-curve::before {
    content: '';
    position: absolute;
    top: -60px;
    left: 0;
    right: 0;
    height: 120px;
    background: white;
    border-radius: 0 0 60% 60%;
    transform: scaleX(1.2);
}

.cta-section.bottom-curve {
    padding: 100px 0 150px;
}

.cta-section.bottom-curve::after {
    content: '';
    position: absolute;
    bottom: -60px;
    left: 0;
    right: 0;
    height: 120px;
    background: white;
    border-radius: 60% 60% 0 0;
    transform: scaleX(1.2);
}

.cta-section.side-curves::before {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    left: -50px;
    width: 100px;
    background: white;
    border-radius: 0 50% 50% 0;
    transform: scaleY(1.1);
}

.cta-section.side-curves::after {
    content: '';
    position: absolute;
    top: 0;
    bottom: 0;
    right: -50px;
    width: 100px;
    background: white;
    border-radius: 50% 0 0 50%;
    transform: scaleY(1.1);
}

.cta-section.clip-path {
    clip-path: polygon(
        0 0,     /* top-left */
        100% 0,  /* top-right */
        100% 85%, /* right-middle */
        0 100%   /* bottom-left */
    );
}


.cta-title {
    font-size: 2.5rem;
    font-weight: 700;
    margin-bottom: 1rem;
    text-align: center;
}

.cta-subtitle {
    font-size: 1.25rem;
    opacity: 0.9;
    text-align: center;
    margin-bottom: 50px;
    max-width: 700px;
    margin-left: auto;
    margin-right: auto;
}

.contact-form {
    background: white;
    border-radius: 20px;
    padding: 50px;
    max-width: 900px;
    margin: 0 auto;
    box-shadow: 0 30px 60px rgba(0,0,0,0.2);
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 25px;
    margin-bottom: 30px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-group label {
    font-weight: 600;
    margin-bottom: 8px;
    color: #1e293b;
    font-size: 0.95rem;
}

.form-group input,
.form-group select,
.form-group textarea {
    padding: 15px;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    font-size: 1rem;
    transition: all 0.3s ease;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #1d4ed8;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-group textarea {
    min-height: 120px;
    resize: vertical;
}

.form-footer {
    text-align: center;
}

.submit-btn {
    background: #1d4ed8;
    color: white;
    border: none;
    padding: 18px 40px;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-bottom: 20px;
}

.submit-btn:hover:not(:disabled) {
    background: #5a67d8;
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
}

.submit-btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}

.form-note {
    color: #64748b;
    font-size: 0.9rem;
}

/* FAQ Section */
.faq-section {
    padding: 100px 0;
    background: #f8fafc;
}

.faq-list {
    max-width: 800px;
    margin: 0 auto;
}

.faq-item {
    background: white;
    border-radius: 15px;
    margin-bottom: 15px;
    overflow: hidden;
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
}

.faq-question {
    padding: 25px 30px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: background 0.3s ease;
}

.faq-question:hover {
    background: #f8fafc;
}

.faq-question h3 {
    font-size: 1.1rem;
    font-weight: 600;
    color: #1e293b;
    margin: 0;
}

.faq-question i {
    color: #1d4ed8;
    transition: transform 0.3s ease;
}

.faq-answer {
    padding: 0 30px 25px;
    color: #475569;
    line-height: 1.6;
}

/* Responsive Design */
@media (max-width: 992px) {
    .hero-section .container {
        flex-direction: column;
        text-align: center;
    }
    
    .hero-title {
        font-size: 2.5rem;
    }
    
    .models-grid {
        grid-template-columns: 1fr;
    }
    
    .model-card.featured {
        transform: none;
    }
    
    .form-grid {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .hero-title {
        font-size: 2rem;
    }
    
    .section-title {
        font-size: 2rem;
    }
    
    .contact-form {
        padding: 30px 20px;
    }
    
    .hero-actions {
        flex-direction: column;
        align-items: center;
    }
    
    .btn-primary, .btn-secondary {
        width: 100%;
        text-align: center;
    }
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes floatIn {
    from {
        opacity: 0;
        transform: translateX(30px) perspective(1000px) rotateY(-10deg);
    }
    to {
        opacity: 1;
        transform: translateX(0) perspective(1000px) rotateY(-5deg);
    }
}

/* Responsive Design */
@media (max-width: 1200px) {
    .hero-title {
        font-size: 3.25rem;
    }
    
    .hero-subtitle {
        font-size: 1.3rem;
    }
}

@media (max-width: 992px) {
    .hero-section {
        padding: 100px 0 80px;
    }
    
    .hero-section .container {
        flex-direction: column;
        text-align: center;
        gap: 50px;
    }
    
    .hero-title {
        font-size: 2.8rem;
        line-height: 1.15;
    }
    
    .hero-subtitle {
        font-size: 1.2rem;
        max-width: 100%;
        margin: 0 auto 2rem;
    }
    
    .hero-actions {
        justify-content: center;
        margin-top: 30px;
    }
    
    .hero-image img {
        max-width: 80%;
        transform: perspective(1000px) rotateY(0deg);
    }
    
    .hero-image:hover img {
        transform: perspective(1000px) rotateY(0deg);
    }
}

@media (max-width: 768px) {
    .hero-title {
        font-size: 2.4rem;
    }
    
    .hero-subtitle {
        font-size: 1.1rem;
    }
    
    .btn-primary, .btn-secondary {
        padding: 16px 32px;
        font-size: 1rem;
        min-width: 180px;
    }
    
    .hero-actions {
        gap: 15px;
    }
    
    .hero-image img {
        max-width: 90%;
    }
}

@media (max-width: 576px) {
    .hero-section {
        padding: 80px 0 60px;
    }
    
    .hero-title {
        font-size: 2rem;
    }
    
    .hero-subtitle {
        font-size: 1rem;
    }
    
    .hero-actions {
        flex-direction: column;
        align-items: center;
        gap: 12px;
    }
    
    .btn-primary, .btn-secondary {
        width: 100%;
        max-width: 300px;
    }
}
</style>