--究极幻魔兽-幻魔皇
function c77240064.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77240064.spcon)
    e2:SetOperation(c77240064.spop)
    c:RegisterEffect(e2)
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c77240064.efilter)
	c:RegisterEffect(e3)
	
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(94119480,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c77240064.target)
    e4:SetOperation(c77240064.operation)
    c:RegisterEffect(e4)	
	
    --atkdef up
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e5:SetCondition(c77240064.con)
    e5:SetOperation(c77240064.op)
    c:RegisterEffect(e5)
end
------------------------------------------------------------------------
function c77240064.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.CheckReleaseGroup(c:GetControler(),Card.IsRace,1,nil,RACE_FIEND)
end
function c77240064.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsRace,1,1,nil,RACE_FIEND)
    Duel.Release(g,REASON_COST)
end
------------------------------------------------------------------------
function c77240064.filter(c)
    return c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c77240064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c77240064.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77240064.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77240064.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77240064.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Destroy(tc,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetDefense()+tc:GetAttack(),REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			local token=Duel.CreateToken(tp,69890968)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
    end
end
------------------------------------------------------------------------
function c77240064.con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:GetAttack()>c:GetAttack()
end
function c77240064.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_PHASE+RESET_DAMAGE_CAL)
        e1:SetValue(bc:GetAttack())
        c:RegisterEffect(e1)
    end
end

function c77240064.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end