--异色眼刃甲龙
function c1230.initial_effect(c)
	c:EnableReviveLimit()
    --xyz summon
    Xyz.AddProcedure(c,nil,7,2)
	
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c1230.con)
    e1:SetTarget(c1230.target)
    e1:SetOperation(c1230.activate)
    c:RegisterEffect(e1)	
	
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetCondition(c1230.damcon)
    e2:SetTarget(c1230.damtg)
    e2:SetOperation(c1230.damop)
    c:RegisterEffect(e2)	
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(1230,0))
    e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_SUMMON)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c1230.cost)
	e3:SetCondition(c1230.con1)
    e3:SetTarget(c1230.target1)
    e3:SetOperation(c1230.activate1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_FLIP_SUMMON)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON)
    c:RegisterEffect(e5)
end
function c1230.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c1230.filter(c)
    return (c:IsSetCard(0x9f) or (c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)) or c:IsSetCard(0x99)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1230.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c1230.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1230.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c1230.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c1230.damcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c1230.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetBattleTarget():GetBaseAttack()
    if chk==0 then return atk>0 end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(atk)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c1230.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c1230.con1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentChain()==0 and rp==1-tp
end
function c1230.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c1230.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:GetFirst() end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c1230.activate1(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
