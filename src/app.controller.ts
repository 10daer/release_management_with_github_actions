import { Controller, Get, Query } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  // Root endpoint - Welcome message
  @Get()
  getWelcome() {
    return this.appService.getWelcome();
  }

  // 1. Health Check Endpoint
  @Get('health')
  getHealth() {
    return this.appService.getHealthCheck();
  }

  // 2. Add Two Numbers
  @Get('add')
  addNumbers(@Query('a') a: string, @Query('b') b: string) {
    const num1 = parseFloat(a);
    const num2 = parseFloat(b);
    return this.appService.addNumbers(num1, num2);
  }

  // 3. Calculate Square
  @Get('square')
  calculateSquare(@Query('number') number: string) {
    const num = parseFloat(number);
    return this.appService.calculateSquare(num);
  }

  // 4. Reverse String
  @Get('reverse')
  reverseString(@Query('text') text: string) {
    return this.appService.reverseString(text);
  }

  // 5. NEW FEATURE (v2.0.0): Basic Statistics
  @Get('stats')
  calculateStats(@Query('numbers') numbers: string) {
    const values = numbers
      .split(',')
      .map((n) => parseFloat(n))
      .filter((n) => !isNaN(n));

    return this.appService.calculateStats(values);
  }
}
