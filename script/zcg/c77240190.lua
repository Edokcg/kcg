--幻魔教主教(ZCG)
function c77240190.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240190.spcon)
    e1:SetOperation(c77240190.spop)
    c:RegisterEffect(e1)

    --copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240190,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c77240190.target)
	e2:SetOperation(c77240190.operation)
	c:RegisterEffect(e2)

    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77240190,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c77240190.tktg)
    e3:SetOperation(c77240190.tkop)
    c:RegisterEffect(e3)

    --damage
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77240190,2))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCost(c77240190.descost)
    e4:SetOperation(c77240190.desop)
    c:RegisterEffect(e4)
end

function c77240190.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c77240190.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c77240190.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_EFFECT) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_EFFECT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_EFFECT)
end

function c77240190.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local ba=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ba)
		c:RegisterEffect(e1)
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
    Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end

function c77240190.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c77240190.tkop(e,tp,eg,ep,ev,re,r,rp)
    local a=0
    while a<2 do
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,69890968,0,0x4011,1000,1000,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,69890968)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    a=a+1
    end
end

function c77240190.filter(c,e,tp)
    return c:IsCode(69890968)
end

function c77240190.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c77240190.filter,1,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c77240190.filter,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
end

function c77240190.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,1000,REASON_EFFECT)
end