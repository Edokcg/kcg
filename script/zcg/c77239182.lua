--青眼暴君龙(ZCG)
function c77239182.initial_effect(c)
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c77239182.splimit)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c77239182.spcon)
    e2:SetOperation(c77239182.spop)
    c:RegisterEffect(e2)
	--multi atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40044918,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c77239182.mttg)
	e3:SetOperation(c77239182.mtop)
	c:RegisterEffect(e3)
end
---------------------------------------------------------------------------
function c77239182.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c77239182.spfilter(c)
    return c:IsCode(89631139) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c77239182.spfilter1(c)
    return c:IsCode(57470761) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c77239182.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c77239182.spfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,nil,c)
		and Duel.IsExistingMatchingCard(c77239182.spfilter1,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,nil,c)
end
function c77239182.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239182.spfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,1,nil,c)
    local g1=Duel.SelectMatchingCard(tp,c77239182.spfilter1,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,1,nil,c)	 
    g1:Merge(g)	
	c:SetMaterial(g1)
    Duel.SendtoGrave(g1,REASON_COST)
end
--打两下

function c77239182.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c77239182.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tct=0
	if Duel.GetTurnPlayer()==tp then tct=1 end
	if c:IsRelateToEffect(e) then
	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetCondition(c77239182.eacon)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,1+tct)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(77239182,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,0,1+tct)
	end
end

function c77239182.eacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end