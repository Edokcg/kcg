--奥利哈刚 黑暗大法师
function c77239291.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239291.spcon)
    e1:SetOperation(c77239291.spop)
    c:RegisterEffect(e1)

	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_DELAY)	
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_SET_ATTACK_FINAL)
    e2:SetCondition(c77239291.atkcon)	
    e2:SetValue(c77239291.atkval)
    c:RegisterEffect(e2)

    --超越无限大
    local e001=Effect.CreateEffect(c)
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e001:SetType(EFFECT_TYPE_SINGLE)
	e001:SetCode(EFFECT_OVERINFINITE_ATTACK)
	c:RegisterEffect(e001)
	local e002=Effect.CreateEffect(c)
	e002:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e002:SetType(EFFECT_TYPE_SINGLE)
	e002:SetCode(EFFECT_OVERINFINITE_DEFENSE)
	c:RegisterEffect(e002)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c77239291.target)	
    e3:SetOperation(c77239291.activate)
    c:RegisterEffect(e3)	
	
    --win
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_ADJUST)
    e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetOperation(c77239291.winop)
    c:RegisterEffect(e4)
	--win
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
    e7:SetRange(LOCATION_HAND)	
    e7:SetCode(EVENT_SUMMON_SUCCESS)
    e7:SetOperation(c77239291.winop1)
    c:RegisterEffect(e7)
    local e8=e7:Clone()
    e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e9)
	
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(EVENT_TO_GRAVE)
    e5:SetCondition(c77239291.drcon)
    e5:SetTarget(c77239291.drtg)
    e5:SetOperation(c77239291.drop)
    c:RegisterEffect(e5)
	--[[
	local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCondition(c77239291.drcon)
    e5:SetTarget(c77239291.target1)
    e5:SetOperation(c77239291.activate1)
    c:RegisterEffect(e5)]]
end
-----------------------------------------------------------------
function c77239291.spfilter(c)
    return c:IsSetCard(0xa50) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c77239291.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239291.spfilter,tp,LOCATION_GRAVE,0,10,nil)
end
function c77239291.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239291.spfilter,tp,LOCATION_GRAVE,0,10,10,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
-----------------------------------------------------------------
function c77239291.atkcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77239291.atkval(e,c)
    local c=e:GetHandler()
    --if Duel.GetAttacker()==c then
        local d=Duel.GetAttackTarget()
    --else
        --local d=Duel.GetAttacker()
    --end
    if c:GetAttack()<d:GetAttack() or c:GetAttack()==d:GetAttack() then
        return d:GetAttack()+500
    else return c:GetAttack() end
end
-----------------------------------------------------------------
function c77239291.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c77239291.activate(e,tp,eg,ep,ev,re,r,rp)
    local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)	
    Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
    Duel.BreakEffect()
    if Duel.Draw(tp,h2,REASON_EFFECT)~=0 then
	    local g=Duel.GetOperatedGroup()
	    Duel.ConfirmCards(1-tp,g)	
        local sg=g:Filter(c77239291.cfilter2,nil,e,tp)
        if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77239291,0)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sdg=sg:Select(tp,1,sg:GetCount(),nil)
            Duel.SpecialSummon(sdg,0,tp,tp,true,true,POS_FACEUP)
			Duel.ShuffleHand(tp)
        end          
    end
end
function c77239291.cfilter2(c,e,tp)
    return c:IsSetCard(0xa50) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
-----------------------------------------------------------------
function c77239291.cfilter3(c)
    return c:IsFaceup() and c:IsSetCard(0xa50) and c:IsRace(RACE_SPELLCASTER)
end
function c77239291.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_EXODIA = 0x10
    local g=Duel.GetMatchingGroup(c77239291.cfilter3,tp,LOCATION_ONFIELD,0,nil)
    if g:GetCount()==4 then	
        Duel.Win(tp,WIN_REASON_EXODIA)
    end
end
function c77239291.winop1(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_EXODIA = 0x10
    local g=Duel.GetMatchingGroup(c77239291.cfilter3,tp,LOCATION_ONFIELD,0,nil)
    if g:GetCount()==4 then	
		if e:GetHandler():IsLocation(LOCATION_HAND) then
            local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)		
	        Duel.ConfirmCards(1-tp,g)
			Duel.Win(tp,WIN_REASON_EXODIA)
		end        
    end
end
------------------------------------------------------------------
--[[function c77239291.drcon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and bit.band(r,0x41)==0x41
end
function c77239291.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239291.activate1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_RULE)
    end
end]]

function c77239291.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,0x41)==0x41 and rp~=tp and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77239291.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239291.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_RULE)
    end
end