#include <AccelStepper.h>

// User-defined values
long receivedSteps = 0; // Number of steps
long receivedSpeed = 0; // Steps / second
long receivedAcceleration = 0; // Steps / second^2
char receivedCommand;

// Direction multipliers
int directionMultiplierX = 1; // 1: positive direction, -1: negative direction for X-axis
int directionMultiplierY = 1; // 1: positive direction, -1: negative direction for Y-axis

bool newData, runallowed = false; // Flags for new data from serial and runallowed

// Define stepper motors for X and Y axes
AccelStepper stepperX(1, 5, 4); // Direction Digital 2 (CCW), pulses Digital 3 (CLK) for X-axis
AccelStepper stepperY(1, 3, 2); // Direction Digital 4 (CCW), pulses Digital 5 (CLK) for Y-axis

void setup()
{
    Serial.begin(9600); // Define baud rate
    Serial.println("Demonstration of AccelStepper Library");
    Serial.println("Send 'C' for printing the commands.");

    // Setting up default values for maximum speed and maximum acceleration
    Serial.println("Default speed: 400 steps/s, default acceleration: 800 steps/s^2.");
    stepperX.setMaxSpeed(64000); // Speed = Steps / second
    stepperX.setAcceleration(8000); // Acceleration = Steps /(second)^2

    stepperY.setMaxSpeed(64000); // Speed = Steps / second
    stepperY.setAcceleration(8000); // Acceleration = Steps /(second)^2

    stepperX.disableOutputs(); // Disable outputs for X-axis
    stepperY.disableOutputs(); // Disable outputs for Y-axis
}

void loop()
{
    checkSerial(); // Check serial port for new commands
    RunTheMotorX(); // Function to handle the X-axis motor
    RunTheMotorY(); // Function to handle the Y-axis motor
}

void RunTheMotorX()
{
    if (runallowed == true)
    {
        stepperX.enableOutputs(); // Enable pins for X-axis
        stepperX.run(); // Step the motor (this will step the motor by 1 step at each loop)
    }
    else
    {
        stepperX.disableOutputs(); // Disable outputs for X-axis
        return;
    }
}

void RunTheMotorY()
{
    if (runallowed == true)
    {
        stepperY.enableOutputs(); // Enable pins for Y-axis
        stepperY.run(); // Step the motor (this will step the motor by 1 step at each loop)
    }
    else
    {
        stepperY.disableOutputs(); // Disable outputs for Y-axis
        return;
    }
}

void checkSerial()
{
    if (Serial.available() > 0)
    {
        receivedCommand = Serial.read();
        newData = true;

        if (newData == true)
        {
            switch (receivedCommand)
            {
            case 'E': // Rotate in a positive (clockwise) direction for X-axis
                receivedSteps = Serial.parseFloat();
                receivedSpeed = Serial.parseFloat();
                directionMultiplierX = 1;
                Serial.println("Positive direction for X-axis.");
                RotateRelativeX();
                break;
//200steps for 1cm, 800cm 
            case 'R': // Rotate in a negative (counter-clockwise) direction for X-axis
                receivedSteps = Serial.parseFloat();
                receivedSpeed = Serial.parseFloat();
                directionMultiplierX = -1;
                Serial.println("Negative direction for X-axis.");
                RotateRelativeX();
                break;

            case 'D': // Rotate in a positive (clockwise) direction for Y-axis
                receivedSteps = Serial.parseFloat();
                receivedSpeed = Serial.parseFloat();
                directionMultiplierY = 1;
                Serial.println("Positive direction for Y-axis.");
                RotateRelativeY(); //Q100
                break;

            case 'U': // Rotate in a negative (counter-clockwise) direction for Y-axis
                receivedSteps = Serial.parseFloat();
                receivedSpeed = Serial.parseFloat();
                directionMultiplierY = -1;
                Serial.println("Negative direction for Y-axis.");
                RotateRelativeY();
                break;

            case 'S':
                stepperX.stop(); // Stop the X-axis motor
                stepperX.disableOutputs(); // Disable power for X-axis
                stepperY.stop(); // Stop the Y-axis motor
                stepperY.disableOutputs(); // Disable power for Y-axis
                Serial.println("Stopped.");
                runallowed = false;
                break;

            case 'A':
                runallowed = false;
                stepperX.disableOutputs(); // Disable power for X-axis
                receivedAcceleration = Serial.parseFloat();
                stepperX.setAcceleration(receivedAcceleration); // Update X-axis acceleration
                stepperY.disableOutputs(); // Disable power for Y-axis
                stepperY.setAcceleration(receivedAcceleration); // Update Y-axis acceleration
                Serial.print("New acceleration value: ");
                Serial.println(receivedAcceleration);
                break;

            case 'L':
                runallowed = true;
                stepperX.disableOutputs(); // Disable power for X-axis
                Serial.print("Current location of the X-axis motor: ");
                Serial.println(stepperX.currentPosition());
                stepperY.disableOutputs(); // Disable power for Y-axis
                Serial.print("Current location of the Y-axis motor: ");
                Serial.println(stepperY.currentPosition());
                break;

            case 'H':
                runallowed = true;
                Serial.println("Homing X and Y axes.");
                GoHomeX(); // Run the function to home X-axis
                GoHomeY(); // Run the function to home Y-axis
                break;

            case 'X':
                runallowed = false;
                stepperX.disableOutputs(); // Disable power for X-axis
                stepperX.setCurrentPosition(0); // Reset X-axis current position
                stepperY.disableOutputs(); // Disable power for Y-axis
                stepperY.setCurrentPosition(0); // Reset Y-axis current position
                Serial.println("Current positions are updated to 0.");
                break;

            case 'C':
                PrintCommands(); // Print the commands for controlling the motors
                break;

            default:
                break;
            }
        }
        newData = false;
    }
}

void GoHomeX()
{
    if (stepperX.currentPosition() == 0)
    {
        Serial.println("X-axis is at the home position.");
        stepperX.disableOutputs(); // Disable power for X-axis
    }
    else
    {
        Serial.println("X-axis is goimg to the home position.");
        stepperX.setMaxSpeed(6400); // Set speed for X-axis
        stepperX.moveTo(0); // Set absolute distance to move for X-axis
    }
}

void GoHomeY()
{
    if (stepperY.currentPosition() == 0)
    {
        Serial.println("Y-axis is at the home position.");
        stepperY.disableOutputs(); // Disable power for Y-axis
    }
    else
    {
        Serial.println("Y-axis is goimg to the home position.");
        stepperY.setMaxSpeed(6400); // Set speed for Y-axis
        stepperY.moveTo(0); // Set absolute distance to move for Y-axis
    }
}

void RotateRelativeX()
{
    runallowed = true;
    stepperX.setMaxSpeed(receivedSpeed);
    stepperX.move(directionMultiplierX * receivedSteps);
}

void RotateRelativeY()
{
    runallowed = true;
    stepperY.setMaxSpeed(receivedSpeed);
    stepperY.move(directionMultiplierY * receivedSteps);
}

void PrintCommands()
{
    Serial.println(" 'C' : Prints all the commands and their functions.");
    Serial.println(" 'P' : Rotates the X-axis motor in positive (CW) direction, relative.");
    Serial.println(" 'N' : Rotates the X-axis motor in negative (CCW) direction, relative.");
    Serial.println(" 'Q' : Rotates the Y-axis motor in positive (CW) direction, relative.");
    Serial.println(" 'W' : Rotates the Y-axis motor in negative (CCW) direction, relative.");
    Serial.println(" 'S' : Stops the motors immediately.");
    Serial.println(" 'A' : Sets an acceleration value.");
    Serial.println(" 'L' : Prints the current position/location of the motors.");
    Serial.println(" 'H' : Goes back to 0 position from the current position (homing) for X and Y axes.");
    Serial.println(" 'U' : Updates the current positions and makes them as the new 0 positions for X and Y axes.");
}
