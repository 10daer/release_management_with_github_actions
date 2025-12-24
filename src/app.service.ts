import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  // Welcome message
  getWelcome() {
    return {
      message: 'Welcome to Simple NestJS API',
      version: '1.0.0',
      endpoints: [
        { path: '/health', method: 'GET', description: 'Health check' },
        {
          path: '/add?a=5&b=10',
          method: 'GET',
          description: 'Add two numbers',
        },
        {
          path: '/square?number=7',
          method: 'GET',
          description: 'Calculate square',
        },
        {
          path: '/reverse?text=hello',
          method: 'GET',
          description: 'Reverse a string',
        },
      ],
    };
  }

  // Health Check
  getHealthCheck() {
    return {
      status: 'OK',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      message: 'Application is running successfully',
    };
  }

  // Add two numbers
  addNumbers(a: number, b: number) {
    const result = a + b;
    return {
      operation: 'addition',
      input: { a, b },
      result: result,
    };
  }

  // Calculate square of a number
  calculateSquare(num: number) {
    const result = num * num;
    return {
      operation: 'square',
      input: num,
      result: result,
    };
  }

  // Reverse a string
  reverseString(text: string) {
    const reversed = text.split('').reverse().join('');
    return {
      operation: 'reverse',
      input: text,
      result: reversed,
    };
  }
}
