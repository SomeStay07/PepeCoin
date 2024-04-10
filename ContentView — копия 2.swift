import SwiftUI
import Combine

public protocol TxBlinkerConfiguration {
    var animationTimestamp: TxBlinkerAnimationTimestamp { get }
    var waveConfiguration: TxBlinkerWaveConfiguration { get }
    var dotConfiguration: TxBlinkerDotConfiguration { get }
}

public protocol TxBlinkerAnimationTimestamp {
    var step1Animation: Double { get }
    var step2Animation: Double { get }
    var step3Animation: Double { get }
    var step4Animation: Double { get }
}

public protocol TxBlinkerWaveConfiguration {
    var sizes: TxBlinkerElementSizesConfiguration { get }
    var color: Color { get }
    var alphas: TxBlinkerWaveAlphasConfiguration { get }
}

public protocol TxBlinkerWaveAlphasConfiguration {
    var step1Alpha: Double { get }
    var step2Alpha: Double { get }
    var step3Alpha: Double { get }
}

public protocol TxBlinkerDotConfiguration {
    var sizes: TxBlinkerElementSizesConfiguration { get }
    var colors: TxBlinkerDotColorsConfiguration { get }
}

public protocol TxBlinkerDotColorsConfiguration {
    var step1Color: Color { get }
    var step2Color: Color { get }
    var step3Color: Color { get }
}

public protocol TxBlinkerElementSizesConfiguration {
    var step1SizeDp: CGFloat { get }
    var step2SizeDp: CGFloat { get }
    var step3SizeDp: CGFloat { get }
}

public struct DefaultTxBlinkerAnimationTimestamp: TxBlinkerAnimationTimestamp {
    public let step1Animation: Double = 0.0
    public let step2Animation: Double = 0.45
    public let step3Animation: Double = 0.15
    public let step4Animation: Double = 0.25
}

public extension TxBlinkerAnimationTimestamp where Self == DefaultTxBlinkerAnimationTimestamp {
    static var `default`: TxBlinkerAnimationTimestamp { DefaultTxBlinkerAnimationTimestamp() }
}

public struct AccentTxBlinkerDotColorsConfiguration: TxBlinkerDotColorsConfiguration {
    public let step1Color: Color = .red
    public let step2Color: Color = .green
    public let step3Color: Color = .red
}

public struct NeutralTxBlinkerDotColorsConfiguration: TxBlinkerDotColorsConfiguration {
    public let step1Color: Color = .gray
    public let step2Color: Color = .black
    public let step3Color: Color = .gray
}

public extension TxBlinkerDotColorsConfiguration where Self == NeutralTxBlinkerDotColorsConfiguration {
    static var neutral: TxBlinkerDotColorsConfiguration { NeutralTxBlinkerDotColorsConfiguration() }
}

public struct DefaultTxBlinkerDotSize: TxBlinkerElementSizesConfiguration {
    public let step1SizeDp: CGFloat = 8
    public let step2SizeDp: CGFloat = 12
    public let step3SizeDp: CGFloat = 16
}

public extension TxBlinkerElementSizesConfiguration where Self == DefaultTxBlinkerDotSize {
    static var defaultDot: TxBlinkerElementSizesConfiguration { DefaultTxBlinkerDotSize() }
}

public extension TxBlinkerDotColorsConfiguration where Self == AccentTxBlinkerDotColorsConfiguration {
    static var accent: TxBlinkerDotColorsConfiguration { AccentTxBlinkerDotColorsConfiguration() }
}

public struct DefaultTxBlinkerWaveSize: TxBlinkerElementSizesConfiguration {
    public let step1SizeDp: CGFloat = 8
    public let step2SizeDp: CGFloat = 48
    public let step3SizeDp: CGFloat = 72
}

public struct DefaultTxBlinkerWaveAlphasConfiguration: TxBlinkerWaveAlphasConfiguration {
    public let step1Alpha: Double = 0
    public let step2Alpha: Double = 1
    public let step3Alpha: Double = 0
}

public extension TxBlinkerWaveAlphasConfiguration where Self == DefaultTxBlinkerWaveAlphasConfiguration {
    static var `default`: TxBlinkerWaveAlphasConfiguration { DefaultTxBlinkerWaveAlphasConfiguration() }
}

public struct AccentTxBlinkerWaveConfiguration: TxBlinkerWaveConfiguration {
    public let sizes: TxBlinkerElementSizesConfiguration = .defaultWave
    public let color: Color = .pink
    public let alphas: TxBlinkerWaveAlphasConfiguration = .default
}

public extension TxBlinkerWaveConfiguration where Self == AccentTxBlinkerWaveConfiguration {
    static var accent: TxBlinkerWaveConfiguration { AccentTxBlinkerWaveConfiguration() }
}

public extension TxBlinkerElementSizesConfiguration where Self == DefaultTxBlinkerWaveSize {
    static var defaultWave: TxBlinkerElementSizesConfiguration { DefaultTxBlinkerWaveSize() }
}

public struct NeutralTxBlinkerWaveConfiguration: TxBlinkerWaveConfiguration {
    public let sizes: TxBlinkerElementSizesConfiguration = .defaultWave
    public let color: Color = .pink
    public let alphas: TxBlinkerWaveAlphasConfiguration = .default
}

public extension TxBlinkerWaveConfiguration where Self == NeutralTxBlinkerWaveConfiguration {
    static var neutral: TxBlinkerWaveConfiguration { NeutralTxBlinkerWaveConfiguration() }
}

public struct AccentTxBlinkerDotConfiguration: TxBlinkerDotConfiguration {
    public let sizes: TxBlinkerElementSizesConfiguration = .defaultDot
    public let colors: TxBlinkerDotColorsConfiguration = .accent
}

public extension TxBlinkerDotConfiguration where Self == AccentTxBlinkerDotConfiguration {
    static var accent: TxBlinkerDotConfiguration { AccentTxBlinkerDotConfiguration() }
}

public struct AccentTxBlinkerConfiguration: TxBlinkerConfiguration {
    public let animationTimestamp: TxBlinkerAnimationTimestamp = .default
    public let waveConfiguration: TxBlinkerWaveConfiguration = .accent
    public let dotConfiguration: TxBlinkerDotConfiguration = .accent
}

public extension TxBlinkerConfiguration where Self == AccentTxBlinkerConfiguration {
    static var accent: TxBlinkerConfiguration { AccentTxBlinkerConfiguration() }
}

public struct NeutralTxBlinkerConfiguration: TxBlinkerConfiguration {
    public let animationTimestamp: TxBlinkerAnimationTimestamp = .default
    public let waveConfiguration: TxBlinkerWaveConfiguration = .accent
    public let dotConfiguration: TxBlinkerDotConfiguration = .accent
}

public extension TxBlinkerConfiguration where Self == NeutralTxBlinkerConfiguration {
    static var neutral: TxBlinkerConfiguration { NeutralTxBlinkerConfiguration() }
}


struct TxBlinkerView: View {
    @State private var waveSize: CGFloat
    @State private var waveOpacity: Double
    @State private var dotSize: CGFloat
    @State private var dotColor: Color
    @State private var currentStep: Int = 1
    
    private let config: TxBlinkerConfiguration

    var body: some View {
        ZStack {
            Circle()
            .fill(config.waveConfiguration.color)
            .opacity(waveOpacity)
            .frame(width: waveSize, height: waveSize)

            Circle()
            .fill(dotColor)
            .frame(width: dotSize, height: dotSize)
        }
        .onAppear {
            animateToNextStep()
        }
    }
    
    private func aboba() -> [
        (dotSize: CGFloat,
         waveSize: CGFloat,
         opacity: Double,
         color: Color,
         duration: Double)
    ] {
        [
            (dotSize: config.dotConfiguration.sizes.step1SizeDp, 
             waveSize: config.waveConfiguration.sizes.step1SizeDp,
             opacity: config.waveConfiguration.alphas.step1Alpha, 
             color: config.dotConfiguration.colors.step1Color,
             duration: config.animationTimestamp.step1Animation
            ),
            (dotSize: config.dotConfiguration.sizes.step2SizeDp,
             waveSize: config.waveConfiguration.sizes.step2SizeDp,
             opacity: config.waveConfiguration.alphas.step2Alpha,
             color: config.dotConfiguration.colors.step2Color,
             duration: config.animationTimestamp.step2Animation
            ),
            (dotSize: config.dotConfiguration.sizes.step3SizeDp,
             waveSize: config.waveConfiguration.sizes.step3SizeDp,
             opacity: config.waveConfiguration.alphas.step3Alpha,
             color: config.dotConfiguration.colors.step3Color,
             duration: config.animationTimestamp.step3Animation
            ),
            (dotSize: config.dotConfiguration.sizes.step1SizeDp,
             waveSize: config.waveConfiguration.sizes.step1SizeDp,
             opacity: config.waveConfiguration.alphas.step1Alpha,
             color: config.dotConfiguration.colors.step1Color,
             duration: config.animationTimestamp.step4Animation
            )
        ]
    }

    private func animateToNextStep() {
        let step = aboba()[currentStep - 1]
        
        withAnimation(.linear(duration: step.duration)) {
            waveSize = step.waveSize
            waveOpacity = step.opacity
            dotSize = step.dotSize
            dotColor = step.color
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + step.duration) {
            currentStep = currentStep % aboba().count + 1
            animateToNextStep()
        }
    }
    
    init(
        config: TxBlinkerConfiguration
    ) {
        self.config = config
        _waveSize = State(initialValue: config.waveConfiguration.sizes.step1SizeDp)
        _waveOpacity = State(initialValue: config.waveConfiguration.alphas.step1Alpha)
        _dotSize = State(initialValue: config.dotConfiguration.sizes.step1SizeDp)
        _dotColor = State(initialValue: config.dotConfiguration.colors.step1Color)
    }
}

struct TxBlinkerView: View {
    @State private var currentStepIndex = 0 // Используем индекс текущего шага
    
    private let config: TxBlinkerConfiguration
    private var animationSteps: [AnimationStep] // Массив шагов анимации
    
    // Структура для удобной работы с шагами анимации
    private struct AnimationStep {
        var dotSize: CGFloat
        var waveSize: CGFloat
        var opacity: Double
        var color: Color
        var duration: Double
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(config.waveConfiguration.color)
                .opacity(animationSteps[currentStepIndex].opacity)
                .frame(width: animationSteps[currentStepIndex].waveSize, height: animationSteps[currentStepIndex].waveSize)
            
            Circle()
                .fill(animationSteps[currentStepIndex].color)
                .frame(width: animationSteps[currentStepIndex].dotSize, height: animationSteps[currentStepIndex].dotSize)
        }
        .onAppear {
            // Начало анимационного цикла
            animateToNextStep()
        }
    }
    
    init(config: TxBlinkerConfiguration) {
        self.config = config
        
        // Инициализация массива шагов анимации
        animationSteps = [
            AnimationStep(dotSize: config.dotConfiguration.sizes.step1SizeDp, waveSize: config.waveConfiguration.sizes.step1SizeDp, opacity: config.waveConfiguration.alphas.step1Alpha, color: config.dotConfiguration.colors.step1Color, duration: config.animationTimestamp.step1Animation),
            AnimationStep(dotSize: config.dotConfiguration.sizes.step2SizeDp, waveSize: config.waveConfiguration.sizes.step2SizeDp, opacity: config.waveConfiguration.alphas.step2Alpha, color: config.dotConfiguration.colors.step2Color, duration: config.animationTimestamp.step2Animation),
            AnimationStep(dotSize: config.dotConfiguration.sizes.step3SizeDp, waveSize: config.waveConfiguration.sizes.step3SizeDp, opacity: config.waveConfiguration.alphas.step3Alpha, color: config.dotConfiguration.colors.step3Color, duration: config.animationTimestamp.step3Animation),
            AnimationStep(dotSize: config.dotConfiguration.sizes.step1SizeDp, waveSize: config.waveConfiguration.sizes.step1SizeDp, opacity: config.waveConfiguration.alphas.step1Alpha, color: config.dotConfiguration.colors.step1Color, duration: config.animationTimestamp.step4Animation)
        ]
    }
    
    // Анимация к следующему шагу с рекурсивным вызовом для цикла
    private func animateToNextStep() {
        let step = animationSteps[currentStepIndex]
                
        withAnimation(.linear(duration: step.duration)) {
            currentStepIndex = (currentStepIndex + 1) % animationSteps.count
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + step.duration) {
            animateToNextStep()
        }
    }
    
//    withAnimation(.linear(duration: step.duration)) {
//                waveSize = step.waveSize
//                waveOpacity = step.opacity
//                dotSize = step.dotSize
//                dotColor = step.color
//            }
//    
//            DispatchQueue.main.asyncAfter(deadline: .now() + step.duration) {
//                currentStep = currentStep % aboba().count + 1
//                animateToNextStep()
//            }
//
}

struct TxBlinkerView_Previews: PreviewProvider {
    static var previews: some View {
        TxBlinkerView(config: .accent)
    }
}
