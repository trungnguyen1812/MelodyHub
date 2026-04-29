<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ForgotPasswordMail extends Mailable
{
    use Queueable, SerializesModels;

    public string $newPassword;
    public string $userName;

    public function __construct(string $newPassword, string $userName)
    {
        $this->newPassword = $newPassword;
        $this->userName    = $userName;
    }

    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Your new password - ' . config('app.name'),
        );
    }

    public function content(): Content
    {
        return new Content(
            view: 'emails.forgot_password',
        );
    }
}
